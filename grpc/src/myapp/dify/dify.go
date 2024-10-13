package dify

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/signal"
	"regexp"
	"syscall"

	"github.com/joho/godotenv"
	sse "github.com/tmaxmax/go-sse"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type ResponseType struct {
	answer         *string
	TaskID         string
	ConversationID string
}

type Result struct {
	Error     error
	DifyEvent *ResponseType
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
		var eventData EventData
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
