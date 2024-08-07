import 'package:hive/hive.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';
import 'package:myflutterapp/feature/message/usecase/message_data_access.dart';
import 'package:myflutterapp/framework/exception/validation_exception.dart';

part 'message_dao.g.dart';

@HiveType(typeId: 0)
class MessageDao extends HiveObject implements MessageDataAccess {
  @override
  @HiveField(0)
  final MessageId id;

  @override
  @HiveField(1)
  final String text;

  @override
  @HiveField(2)
  final bool isMine;

  @override
  @HiveField(3)
  final int? status;

  @override
  @HiveField(4)
  final DateTime createdAt;

  MessageDao({
    required this.id,
    required this.text,
    required this.isMine,
    required this.status,
    required this.createdAt,
  }) {
    final exceptions = validate();
    if (exceptions.isNotEmpty) {
      throw ValidationsException(exceptions);
    }
  }

  List<ValidationException> validate() => [
        if (isMine && status == null)
          ValidationException('status must not be null when isMine is true'),
        if (text.length >= 1000)
          ValidationException('text must be equal or less than number')
      ];
}
