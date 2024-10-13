package chatgpt

import (
	"encoding/json"
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
		log.Printf("Read IO error: %v\n", err)
		return "", err
	}

	// Convert the response body to a string
	bodyString := string(body)
	// Log the response body
	log.Printf("OpenAI API Response Body: %s\n", bodyString)

	// json decode
	var response struct {
		ID      string `json:"id"`
		Object  string `json:"object"`
		Choices []struct {
			Index   int `json:"index"`
			Message struct {
				Role    string `json:"role"`
				Content string `json:"content"`
			} `json:"message"`
			Logprobs     interface{} `json:"logprobs"`
			FinishReason string      `json:"finish_reason"`
		} `json:"choices"`
		Usage struct {
			PromptTokens     int `json:"prompt_tokens"`
			CompletionTokens int `json:"completion_tokens"`
			TotalTokens      int `json:"total_tokens"`
		} `json:"usage"`
		SystemFingerprint interface{} `json:"system_fingerprint"`
	}

	err = json.Unmarshal(body, &response)
	if err != nil {
		log.Printf("error decoding response body: %v\n", err)
		return "", err
	}

	content := response.Choices[0].Message.Content
	return content, nil
}
