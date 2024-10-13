package main

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"os"
	"os/signal"
	"regexp"
	"syscall"

	// "encoding/json"
	"flag"
	"fmt"
	"log"
	"net"

	// "net/http"
	// "os"
	// "strings"

	"github.com/joho/godotenv"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"

	// "google.golang.org/grpc/metadata"
	sse "github.com/tmaxmax/go-sse"
	"google.golang.org/grpc/reflection"
	"google.golang.org/grpc/status"
	pb "taqucinco.com/myapp/aidog"
	chatgpt "taqucinco.com/myapp/chatgpt"
	dify "taqucinco.com/myapp/dify"
)

// func authVerifyHandler(w http.ResponseWriter, r *http.Request) {

// 	w.Header().Set("Content-Type", "application/json")
// 	idToken := r.Header.Get("Authorization")
// 	fmt.Println("Authorization: ", idToken)
// 	idToken = strings.TrimPrefix(idToken, "Bearer ")

// 	err := features.VerifyIdToken(idToken)
// 	if err != nil {
// 		http.Error(w, err.Error(), http.StatusUnauthorized)
// 	} else {
// 		w.Header().Set("Content-Type", "application/json")
// 		fmt.Fprint(w, `{"message": "ok"}`)
// 	}
// }

func chatGptHandler(question string) (string, error) {

	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
		return "", status.Errorf(codes.Unknown, "Invalid argument:")
	}
	key := os.Getenv("CHATGPT_KEY")

	chat, err := chatgpt.CallChat(
		question+" 回答する時の語尾のが「あります」「です」や「ます」を「ワン」に変えて「...あるワン」「...だワン」、「...であるワン」として犬っぽく答えてください。たまに語尾を「ワンワン」や「ワオン」も混ぜてください。",
		key,
	)

	if err != nil {
		return "", err
	} else {
		return chat, nil
	}
}

func send(question string, conversationId string, ch chan<- Result /*, wg *sync.WaitGroup*/) {
	// defer wg.Done()
	defer close(ch)

	envErr := godotenv.Load()
	if envErr != nil {
		log.Printf("Error loading .env file: %v", envErr)
		ch <- Result{Error: status.Errorf(codes.Unavailable, "%v", envErr), DifyEvent: nil}
		return
	}
	key := os.Getenv("DIFY_API_KEY")
	// fmt.Println(key)

	sseClient := sse.Client{
		Backoff: sse.Backoff{
			MaxRetries: -1,
		},
	}
	userId := "user-123"
	body := `{
		"inputs": {},
		"query": "` + question + `",                  
		"response_mode": "streaming",
		"conversation_id": "` + conversationId + `",
		"user": "` + userId + `",
		"files": []
	}`
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer cancel()
	difyReq, sseErr := http.NewRequestWithContext(ctx, http.MethodPost, "https://api.dify.ai/v1/chat-messages", bytes.NewBuffer([]byte(body)))
	if sseErr != nil {
		log.Printf("Error creating request: %v", sseErr)
		ch <- Result{Error: status.Errorf(codes.Unavailable, "%v", sseErr), DifyEvent: nil}
		return
	}
	difyReq.Header.Set("Authorization", "Bearer "+key)
	difyReq.Header.Set("Content-Type", "application/json")

	conn := sseClient.NewConnection(difyReq)

	unsubscribe := conn.SubscribeMessages(func(ev sse.Event) {
		fmt.Printf(ev.Data + "\n")
		var eventData dify.EventData
		err := json.Unmarshal([]byte(ev.Data), &eventData)
		if err == nil {
			eventName := eventData.Event
			taskID := eventData.TaskID
			conversationID := eventData.ConversationID

			if eventName == "workflow_started" {
				response := ResponseType{
					answer:         nil,
					TaskID:         taskID,
					ConversationID: conversationID,
				}
				ch <- Result{Error: nil, DifyEvent: &response}
			} else if eventName == "message" {
				answer := eventData.Answer
				response := ResponseType{
					answer:         answer,
					TaskID:         taskID,
					ConversationID: conversationID,
				}
				ch <- Result{Error: nil, DifyEvent: &response}
			}
		} else {
			ch <- Result{Error: err, DifyEvent: nil}
		}
	})
	defer unsubscribe()

	err := conn.Connect()
	// "response validation expected status code %d %s, received %d %s"
	if errors.Is(err, io.EOF) {
		fmt.Fprintln(os.Stderr, err)
	} else if err != nil {
		log.Printf("err hoge: %v", err.Error())
		regexp := regexp.MustCompile(`received (\d+)`)
		matches := regexp.FindStringSubmatch(err.Error())
		if len(matches) < 2 {
			ch <- Result{Error: err, DifyEvent: nil}
		} else {
			statusCode := matches[1]
			log.Printf("parsed status code: %s", statusCode)
			if statusCode == "404" {
				ch <- Result{Error: status.Errorf(codes.NotFound, "error: %v", err), DifyEvent: nil}
			} else if statusCode == "408" {
				ch <- Result{Error: status.Errorf(codes.DeadlineExceeded, "error: %v", err), DifyEvent: nil}
			} else {
				ch <- Result{Error: status.Errorf(codes.Unavailable, "error: %v", err), DifyEvent: nil}
			}
		}
	}
}

type ResponseType struct {
	answer         *string
	TaskID         string
	ConversationID string
}

type Result struct {
	Error     error
	DifyEvent *ResponseType
}

var (
	port = flag.Int("port", 50051, "The server port")
)

// server is used to implement pb Server.
type server struct {
	pb.UnimplementedAidogServer
}

func (s *server) Ask(ctx context.Context, in *pb.QaRequest) (*pb.QaResponse, error) {
	log.Printf("Received Ask question: %v", in.GetQuestion())

	// Get the Authorization header value from the gRPC metadata
	// md, ok := metadata.FromIncomingContext(ctx)
	// if !ok {
	// 	return nil, status.Errorf(codes.InvalidArgument, "Failed to get metadata")
	// }
	// authHeaders := md.Get("authorization")
	// if len(authHeaders) == 0 {
	// 	return nil, status.Errorf(codes.Unauthenticated, "Authorization header is missing")
	// }
	// authToken := authHeaders[0]
	// fmt.Println("Authorization: ", authToken)

	answer, err := chatGptHandler(in.GetQuestion())

	if err != nil {
		// https://github.com/googleapis/googleapis/blob/master/google/rpc/code.proto
		return nil, err
	}
	return &pb.QaResponse{Answer: answer}, nil
}

func (s *server) SendQuestion(in *pb.DifyRequest, stream pb.Aidog_SendQuestionServer) error {
	log.Printf("Received DifyGrpc: %v", in.GetName())
	ch := make(chan Result)
	go send(in.GetQuestion(), in.GetConversationId(), ch)
	for {
		result, ok := <-ch
		if !ok {
			fmt.Println("channel closed")
			break
		}
		if result.DifyEvent != nil {
			event := *result.DifyEvent
			res := &pb.DifyResponse{TaskId: event.TaskID, ConversationId: event.ConversationID, Answer: event.answer}
			if err := stream.Send(res); err != nil {
				log.Printf("failed to send: %v", err)
				return err
			}

		} else if result.Error != nil {
			log.Printf("Error gRPC: %v", result.Error)
			return result.Error
		}
	}
	return nil
}

func main() {
	flag.Parse()
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", *port))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterAidogServer(s, &server{})
	reflection.Register(s)
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
