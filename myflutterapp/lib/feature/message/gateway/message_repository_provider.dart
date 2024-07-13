import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/message/gateway/message_repository.dart';
import 'package:myflutterapp/feature/message/gateway/message_repository_impl.dart';

final messageRepositoryProvider =
    Provider<MessageRepository>((ref) => MessageRepositoryImpl(ref));
