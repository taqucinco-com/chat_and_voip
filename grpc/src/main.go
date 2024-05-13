package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	firebase "firebase.google.com/go/v4"
)

func handler(w http.ResponseWriter, r *http.Request) {
	// https://firebase.google.com/docs/admin/setup?hl=ja#go

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

	token, err := client.VerifyIDToken(context.Background(), idToken)
	if err != nil {
		log.Fatalf("error verifying ID token: %v\n", err)
	}

	log.Printf("Verified ID token: %v\n", token)
	fmt.Fprint(w, `{"message": "hello, golang"}`)
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
