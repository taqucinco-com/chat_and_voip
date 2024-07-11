import 'package:hive/hive.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';

part 'message_dao.g.dart';

@HiveType(typeId: 0)
class MessageDao extends HiveObject
    implements MessageEntity, MessageEntityWithStatus {
  @override
  @HiveField(0)
  final MessageId id;

  @override
  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isMine;

  @override
  @HiveField(3)
  final MessageStatus? status;

  @override
  @HiveField(4)
  final DateTime createdAt;

  MessageDao({
    required this.id,
    required this.text,
    required this.isMine,
    required this.status,
    required this.createdAt,
  });
}
