import 'package:myflutterapp/feature/message/domain/message_entity.dart';
import 'package:myflutterapp/feature/message/domain/message_object.dart';

abstract interface class MessageDataAccess {
  final MessageId id;
  final String text;
  final bool isMine;
  final int? status;
  final DateTime createdAt;

  MessageDataAccess({
    required this.id,
    required this.text,
    required this.isMine,
    required this.status,
    required this.createdAt,
  });
}

mixin MessageAdaptor {
  MessageEither adapt(MessageDataAccess messageDataAccess) {
    if (messageDataAccess.isMine) {
      return MyMessageObject.from(messageDataAccess);
    } else {
      return AiMessageObject(
        id: messageDataAccess.id,
        text: messageDataAccess.text,
        createdAt: messageDataAccess.createdAt,
      );
    }
  }
}
