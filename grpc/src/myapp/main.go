package main

import (
	"features"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/joho/godotenv"
)

func authVerifyHandler(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Content-Type", "application/json")
	idToken := r.Header.Get("Authorization")
	fmt.Println("Authorization: ", idToken)
	idToken = strings.TrimPrefix(idToken, "Bearer ")

	err := features.VerifyIdToken(idToken)
	if err != nil {
		http.Error(w, err.Error(), http.StatusUnauthorized)
	} else {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"message": "ok"}`)
	}
}

func chatGptHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}
	key := os.Getenv("CHATGPT_KEY")

	chat, err := features.CallChat(
		"今日の蟹座の、ラッキーアイテムを1つ教えてください。回答する時の語尾の「です」や「ます」に「ワン」を追加して「...ですワン」、「...ますワン」として犬っぽく答えてください。",
		key,
	)
	log.Printf("OpenAI API: %v\n", chat)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	} else {
		// Set the response headers
		w.Header().Set("Content-Type", "application/json")
		// Write the response body to the HTTP response
		fmt.Fprint(w, chat)
	}
}

func main() {
	http.HandleFunc("/auth/verify", authVerifyHandler)
	http.HandleFunc("/ai", chatGptHandler)
	http.ListenAndServe(":8080", nil)
}
