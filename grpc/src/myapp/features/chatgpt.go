package features

import (
	"io"
	"log"
	"net/http"
	"strings"
)

func CallChat(prompt string, key string) (string, error) {
	payload := `{
		"model": "gpt-3.5-turbo",
		"messages": [
			{"role": "system", "content": "You are a helpful assistant."},
			{"role": "user", "content": "` + prompt + `"}
		],
		"temperature": 1,
		"max_tokens": 500
	}`

	// Set the request headers
	headers := map[string]string{
		"Content-Type":  "application/json",
		"Authorization": "Bearer " + key,
	}

	// Send the POST request to OpenAI API
	req, err := http.NewRequest("POST", "https://api.openai.com/v1/chat/completions", strings.NewReader(payload))
	if err != nil {
		log.Printf("error creating request to OpenAI API: %v\n", err)
		return "", err
	}
	for key, value := range headers {
		req.Header.Set(key, value)
	}
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Printf("error sending request to OpenAI API: %v\n", err)
		return "", err
	}
	defer resp.Body.Close()

	// Read the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Printf("error reading response body: %v\n", err)
		return "", err
	}

	return string(body), nil
}
