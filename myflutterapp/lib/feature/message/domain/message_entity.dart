enum MessageStatus {
  sending(0),
  replied(1);

  const MessageStatus(this.code);
  final int code;
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

sealed class MessageEither implements MessageEntity {}

abstract class MyMessageEntity extends MessageEither
    implements MessageEntityWithStatus {
  MyMessageEntity copyWith({String? text, MessageStatus? status});
}

abstract class AiMessageEntity extends MessageEither {}

class MyMessageObject implements MyMessageEntity {
  @override
  final MessageId id;
  @override
  final String text;
  @override
  final DateTime createdAt;
  @override
  final MessageStatus? status;

  MyMessageObject({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.status,
  });

  @override
  MyMessageEntity copyWith({String? text, MessageStatus? status}) =>
      MyMessageObject(
        id: id,
        text: text ?? this.text,
        createdAt: createdAt,
        status: status ?? this.status,
      );
}

class AiMessageObject implements AiMessageEntity {
  @override
  final MessageId id;
  @override
  final String text;
  @override
  final DateTime createdAt;

  AiMessageObject({
    required this.id,
    required this.text,
    required this.createdAt,
  });
}
