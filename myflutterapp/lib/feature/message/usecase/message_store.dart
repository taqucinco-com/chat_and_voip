import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';

class MyMessagesNotifier extends StateNotifier<List<MyMessageEntity>> {
  MyMessagesNotifier() : super([]);

  void add(List<MyMessageEntity> entities) {
    state = [...state, ...entities];
  }

  void replace(MyMessageEntity entity) {
    state = state.map((v) => (v.id == entity.id) ? entity : v).toList();
  }
}

class AiMessagesNotifier extends StateNotifier<List<AiMessageEntity>> {
  AiMessagesNotifier() : super([]);

  void add(List<AiMessageEntity> entities) {
    state = [...state, ...entities];
  }
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

  return [...mine, ...ai]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
});
