package dify

type EventData struct {
	Event          string  `json:"event"`
	TaskID         string  `json:"task_id"`
	ConversationID string  `json:"conversation_id"`
	Answer         *string `json:"answer"`
}
