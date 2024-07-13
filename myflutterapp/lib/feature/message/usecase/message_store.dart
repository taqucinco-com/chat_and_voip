import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';

class MyMessagesNotifier extends StateNotifier<List<MyMessageEntity>> {
  MyMessagesNotifier() : super([]);
}

class AiMessagesNotifier extends StateNotifier<List<AiMessageEntity>> {
  AiMessagesNotifier() : super([]);
}

final myMessagesProvider =
    StateNotifierProvider<MyMessagesNotifier, List<MyMessageEntity>>((ref) {
  return MyMessagesNotifier();
});

final aiMessagesProvider =
    StateNotifierProvider<AiMessagesNotifier, List<AiMessageEntity>>((ref) {
  return AiMessagesNotifier();
});

final messagesProvider = Provider<List<MessageEither>>((ref) {
  final mine = ref.watch(myMessagesProvider);
  final ai = ref.watch(aiMessagesProvider);

  return [...mine, ...ai];
});
