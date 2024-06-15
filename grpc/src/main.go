package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"strings"

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

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
