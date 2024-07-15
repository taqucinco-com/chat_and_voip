import 'package:myflutterapp/feature/message/domain/message_entity.dart';
import 'package:myflutterapp/feature/message/usecase/message_data_access.dart';
import 'package:myflutterapp/framework/exception/validation_exception.dart';

class MyMessageObject implements MyMessageEntity {
  @override
  final MessageId id;
  @override
  final String text;
  @override
  final DateTime createdAt;
  @override
  final MessageStatus status;

  MyMessageObject({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.status,
  }) {
    final exceptions = validate();
    if (exceptions.isNotEmpty) {
      throw ValidationsException(exceptions);
    }
  }

  List<ValidationException> validate() => [
        if (text.length >= 1000)
          ValidationException('text must be equal or less than number'),
      ];

  @override
  MyMessageEntity copyWith({String? text, MessageStatus? status}) =>
      MyMessageObject(
        id: id,
        text: text ?? this.text,
        createdAt: createdAt,
        status: status ?? this.status,
      );

  factory MyMessageObject.from(MessageDataAccess messageDataAccess) {
    final status = messageDataAccess.status;
    if (status == null) {
      throw ValidationException('Unknown MessageStatus code: $status');
    }
    final mesStatus = MessageStatus.fromCode(status);

    return MyMessageObject(
      id: messageDataAccess.id,
      text: messageDataAccess.text,
      createdAt: messageDataAccess.createdAt,
      status: mesStatus,
    );
  }
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
