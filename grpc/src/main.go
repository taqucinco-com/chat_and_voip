package main

import (
	"fmt"
	"net/http"
	"context"
	firebase "firebase.google.com/go/v4"
	"log"
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

	w.Header().Set("Content-Type", "application/json")
	auth := r.Header.Get("Authorization")
	fmt.Println("Authorization: ", auth)
	fmt.Fprint(w, `{"message": "hello, golang"}`)
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
