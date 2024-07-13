import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/driver/db/hive_box.dart';
import 'package:myflutterapp/feature/id/ulid_generator.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';
import 'package:myflutterapp/feature/message/gateway/message_dao.dart';
import 'package:myflutterapp/feature/message/gateway/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final ProviderRef<dynamic> ref;
  MessageRepositoryImpl(this.ref);

  @override
  Future<MessageDao?> read(MessageId id) async {
    final box = ref.read(messageBoxProvider);
    final message = box.get(id);
    return message;
  }

  @override
  Future<List<MessageDao>> readQuery({int? limit, int? offset}) async {
    final box = ref.read(messageBoxProvider);
    final iterator = box.valuesBetween(
        startKey: offset ?? 0, endKey: (offset ?? 0) + (limit ?? 100));
    final messages = iterator.map((v) => v as MessageDao).toList();
    return messages;
  }

  @override
  Future<MessageDao> create(
      String text, bool isMine, MessageStatus? status) async {
    final box = ref.read(messageBoxProvider);
    final ulidGen = ref.read(ulidGeneratorProvider);
    final message = MessageDao(
      id: ulidGen(),
      text: text,
      isMine: isMine,
      status: status,
      createdAt: DateTime.now(),
    );
    await box.put(message.id, message);

    return message;
  }

  @override
  Future<MessageDao?> update(MessageId id,
      {String? text, bool? isMine, MessageStatus? status}) async {
    final box = ref.read(messageBoxProvider);
    final message = await read(id);

    if (message == null) return null;

    final updated = MessageDao(
      id: id,
      text: text ?? message.text,
      isMine: isMine ?? message.isMine,
      status: status ?? message.status,
      createdAt: message.createdAt,
    );
    message.delete();
    await box.put(id, updated);
    return updated;
  }
}
