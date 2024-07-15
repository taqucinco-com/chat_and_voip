import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/driver/http/client_channel_establisher_provider.dart';
import 'package:myflutterapp/feature/aidog/aidog_provider.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';
import 'package:myflutterapp/feature/message/gateway/message_repository_provider.dart';
import 'package:myflutterapp/feature/message/usecase/message_data_access.dart';
import 'package:myflutterapp/feature/message/usecase/message_send_progress.dart';
import 'package:myflutterapp/feature/message/usecase/message_store.dart';
import 'package:myflutterapp/feature/message/usecase/message_usecase.dart';

class MessageInteractor with MessageAdaptor implements MessageUseCase {
  final ProviderRef<dynamic> ref;
  MessageInteractor(this.ref);

  @override
  Future<int> initialLoad() async {
    final repo = ref.read(messageRepositoryProvider);
    final messages = await repo.readQuery(offset: 0, limit: 20);

    final mine = messages.fold(<MyMessageEntity>[], (acc, current) {
      final entity = adapt(current);
      switch (entity) {
        case MyMessageEntity _:
          return [...acc, entity];
        case AiMessageEntity _:
          return acc;
      }
    });
    final myMessagesNotifier = ref.read(myMessagesProvider.notifier);
    myMessagesNotifier.add(mine);

    final ai = messages.fold(<AiMessageEntity>[], (acc, current) {
      final entity = adapt(current);
      switch (entity) {
        case MyMessageEntity _:
          return acc;
        case AiMessageEntity _:
          return [...acc, entity];
      }
    });
    final aiMessagesNotifier = ref.read(aiMessagesProvider.notifier);
    aiMessagesNotifier.add(ai);

    return messages.length;
  }

  @override
  Stream<MessageSendProgress> send(String question) async* {
    final repo = ref.read(messageRepositoryProvider);
    try {
      // repoに送信中として格納して状態に反映させる
      final myDao = await repo.create(question, true, MessageStatus.sending);
      final myMessagesNotifier = ref.read(myMessagesProvider.notifier);

      final myEntity = adapt(myDao);
      switch (myEntity) {
        case MyMessageEntity _:
          myMessagesNotifier.add([myEntity]);
        case AiMessageEntity _:
          throw Exception('AiMessageEntity is not expected');
      }
      yield MessageSendProgressSending(myEntity);

      // aiに質問を投げる
      final ask = ref.read(aiDogAskProvider);
      final establish = ref.read(clientChannelEstablisherProvider);
      final answer = await ask(question, establish)
          .catchError((e) => throw _Exception(myEntity.id));

      // 回答を得たので送信中から返答済みにする
      final aiDao = await repo
          .create(answer, false, null)
          .catchError((e) => throw _Exception(myEntity.id));
      final _ = await repo
          .update(myEntity.id, status: MessageStatus.replied)
          .catchError((e) => throw _Exception(myEntity.id));
      myMessagesNotifier
          .replace(myEntity.copyWith(status: MessageStatus.replied));

      final aiMessagesNotifier = ref.read(aiMessagesProvider.notifier);

      final aiEntity = adapt(aiDao);
      switch (aiEntity) {
        case MyMessageEntity _:
          throw Exception('AiMessageEntity is not expected');
        case AiMessageEntity _:
          aiMessagesNotifier.add([aiEntity]);
      }
      yield MessageSendProgressReplied(aiEntity);
    } on _Exception catch (e) {
      final _ = await repo.update(e.id, status: MessageStatus.pended);
      yield MessageSendProgressPended();
    }
  }
}

class _Exception implements Exception {
  final MessageId id;
  _Exception(this.id);
}
