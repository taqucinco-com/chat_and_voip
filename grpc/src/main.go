package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"

	firebase "firebase.google.com/go/v4"
)

func authVerifyHandler(w http.ResponseWriter, r *http.Request) {
	// https://firebase.google.com/docs/admin/setup?hl=ja#go

	if r.Method != http.MethodPost {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	// Initialize default app
	app, err := firebase.NewApp(context.Background(), nil)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
	}

	// Access auth service from the default app
	client, err := app.Auth(context.Background())
	if err != nil {
		log.Fatalf("error getting Auth client: %v\n", err)
	}
	fmt.Println(client)

	w.Header().Set("Content-Type", "application/json")
	idToken := r.Header.Get("Authorization")
	fmt.Println("Authorization: ", idToken)
	idToken = strings.TrimPrefix(idToken, "Bearer ")

	token, err := client.VerifyIDTokenAndCheckRevoked(context.Background(), idToken)
	if err != nil {
		if err.Error() == "ID token has been revoked" {
			// Token is revoked. Inform the user to reauthenticate or signOut() the user.
			log.Printf("Verified ID token: %v\n", token)
			fmt.Fprint(w, `{"message": "Verified ID token is revoked."}`)
		} else {
			// Token is invalid
			log.Fatalf("error verifying ID token: %v\n", err)
		}
	} else {
		log.Printf("Verified ID token: %v\n", token)
		fmt.Fprint(w, `{"message": "Verified ID token is valid."}`)
	}
}

func chatGptHandler(w http.ResponseWriter, r *http.Request) {
	// Prepare the request payload
	payload := `{
		"model": "gpt-3.5-turbo",
		"messages": [
			{"role": "system", "content": "You are a helpful assistant."},
			{"role": "user", "content": "今日の蟹座の、ラッキーアイテムを1つ教えてください。回答する時の語尾の「です」や「ます」に「ワン」を追加して「...ですワン」、「...ますワン」として犬っぽく答えてください。"}
		],
		"temperature": 1,
		"max_tokens": 500
	}`

	// Set the request headers
	headers := map[string]string{
		"Content-Type":  "application/json",
		"Authorization": "Bearer YOUR_TOKEN",
	}

	// Send the POST request to OpenAI API
	req, err := http.NewRequest("POST", "https://api.openai.com/v1/chat/completions", strings.NewReader(payload))
	if err != nil {
		log.Fatalf("error creating request to OpenAI API: %v\n", err)
	}
	for key, value := range headers {
		req.Header.Set(key, value)
	}
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Fatalf("error sending request to OpenAI API: %v\n", err)
	}
	defer resp.Body.Close()

	// Read the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("error reading response body: %v\n", err)
	}

	// Set the response headers
	w.Header().Set("Content-Type", "application/json")

	// Write the response body to the HTTP response
	w.Write(body)
}

func main() {
	http.HandleFunc("/auth/verify", authVerifyHandler)
	http.HandleFunc("/ai", chatGptHandler)
	http.ListenAndServe(":8080", nil)
}
