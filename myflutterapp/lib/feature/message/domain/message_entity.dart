import 'package:myflutterapp/framework/exception/validation_exception.dart';

enum MessageStatus {
  sending(0),
  pended(1),
  replied(2);

  const MessageStatus(this.code);
  final int code;

  factory MessageStatus.fromCode(int code) {
    switch (code) {
      case 0:
        return sending;
      case 1:
        return pended;
      case 2:
        return replied;
      default:
        throw ValidationException('Unknown MessageStatus code: $code');
    }
  }
}

typedef MessageId = String;

abstract interface class MessageEntity {
  MessageId get id;
  String get text;
  DateTime get createdAt;

  // List<ValidationException> validate();
}

abstract interface class MessageEntityWithStatus {
  MessageStatus get status;
}

sealed class MessageEither implements MessageEntity {}

abstract interface class MyMessageEntity extends MessageEither
    implements MessageEntityWithStatus {
  MyMessageEntity copyWith({String? text, MessageStatus? status});
}

abstract interface class AiMessageEntity extends MessageEither {
  // @override
  // List<ValidationException> validate() => [];
}
