package main

import (
	"context"
	"features"
	"os"

	// "encoding/json"
	// "features"
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
	"google.golang.org/grpc/reflection"
	"google.golang.org/grpc/status"
	pb "taqucinco.com/myapp/aidog"
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

	chat, err := features.CallChat(
		question+" 回答する時の語尾のが「あります」「です」や「ます」を「ワン」に変えて「...あるワン」「...だワン」、「...であるワン」として犬っぽく答えてください。",
		key,
	)

	if err != nil {
		return "", err
	} else {
		return chat, nil
	}
}

var (
	port = flag.Int("port", 50051, "The server port")
)

// server is used to implement helloworld.GreeterServer.
type server struct {
	pb.UnimplementedAidogServer
}

func (s *server) Ask(ctx context.Context, in *pb.QaRequest) (*pb.QaResponse, error) {
	log.Printf("Received Ask question: %v", in.GetQuestion())
	answer, err := chatGptHandler(in.GetQuestion())

	if err != nil {
		// https://github.com/googleapis/googleapis/blob/master/google/rpc/code.proto
		return nil, err
	}
	return &pb.QaResponse{Answer: answer}, nil
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
