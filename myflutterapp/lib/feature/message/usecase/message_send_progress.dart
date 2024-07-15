import 'package:myflutterapp/feature/message/domain/message_entity.dart';

sealed class MessageSendProgress {}

class MessageSendProgressSending extends MessageSendProgress {
  final MessageEntity entity;
  MessageSendProgressSending(this.entity);
}

class MessageSendProgressPended extends MessageSendProgress {
  MessageSendProgressPended();
}

class MessageSendProgressReplied extends MessageSendProgress {
  final MessageEntity reply;
  MessageSendProgressReplied(this.reply);
}
