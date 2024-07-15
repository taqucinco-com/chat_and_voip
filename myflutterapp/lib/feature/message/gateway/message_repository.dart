import 'package:myflutterapp/feature/message/domain/message_entity.dart';
import 'package:myflutterapp/feature/message/usecase/message_data_access.dart';

const messageDaoBoxName = 'message_dao';

// gateway for DB
abstract class MessageRepository {
  Future<MessageDataAccess?> read(MessageId id);
  Future<List<MessageDataAccess>> readQuery({int? limit, int? offset});
  Future<MessageDataAccess> create(
      String text, bool isMine, MessageStatus? status);
  Future<MessageDataAccess?> update(MessageId id,
      {String? text, bool? isMine, MessageStatus? status});
}
