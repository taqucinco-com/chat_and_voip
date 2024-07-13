import 'package:myflutterapp/feature/message/gateway/message_dao.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';

const messageDaoBoxName = 'message_dao';

// gateway for DB
abstract class MessageRepository {
  Future<MessageDao?> read(MessageId id);
  Future<List<MessageDao>> readQuery({int? limit, int? offset});
  Future<MessageDao> create(String text, bool isMine, MessageStatus? status);
  Future<MessageDao?> update(MessageId id,
      {String? text, bool? isMine, MessageStatus? status});
}
