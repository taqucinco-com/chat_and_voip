import 'package:myflutterapp/feature/message/gateway/message_dao.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';

// gateway for DB
abstract class MessageRepository {
  Future<MessageDao> read(MessageId id);
  Future<MessageDao> readQuery({int limit});
  Future<MessageDao> create(MessageEntity entity);
  Future<MessageDao> update(MessageEntity entity);
}
