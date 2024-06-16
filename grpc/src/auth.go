package main

import (
	"context"
	"fmt"
	"log"

	firebase "firebase.google.com/go/v4"
)

func verifyIdToken(idToken string) error {
	// https://firebase.google.com/docs/admin/setup?hl=ja#go

	// Initialize default app
	app, err := firebase.NewApp(context.Background(), nil)
	if err != nil {
		return fmt.Errorf("error initializing app: %v", err)
	}

	// Access auth service from the default app
	client, err := app.Auth(context.Background())
	if err != nil {
		return fmt.Errorf("error getting Auth client: %v", err)
	}
	fmt.Println(client)

	token, err := client.VerifyIDTokenAndCheckRevoked(context.Background(), idToken)
	if err != nil {
		// https://firebase.google.com/docs/auth/admin/manage-sessions?hl=ja
		// Token is invalid
		log.Printf("error verifying ID token: %v\n", err)
		return err
	}
	log.Printf("Verified ID token: %v\n", token)
	return nil
}
