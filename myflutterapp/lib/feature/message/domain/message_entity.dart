enum MessageStatus {
  sending,
  replied,
}

typedef MessageId = String;

abstract class MessageEntity {
  MessageId get id;
  String get text;
  DateTime get createdAt;
}

abstract class MessageEntityWithStatus {
  MessageStatus? get status;
}

sealed class MessageEither {}

abstract class MyMessageEntity extends MessageEither
    implements MessageEntity, MessageEntityWithStatus {}

abstract class AiMessageEntity extends MessageEither implements MessageEntity {}
