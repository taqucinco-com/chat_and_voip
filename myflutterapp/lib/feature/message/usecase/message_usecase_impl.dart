import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/driver/http/client_channel_establisher_provider.dart';
import 'package:myflutterapp/feature/aidog/aidog_provider.dart';
import 'package:myflutterapp/feature/message/domain/message_entity.dart';
import 'package:myflutterapp/feature/message/gateway/message_repository_provider.dart';
import 'package:myflutterapp/feature/message/usecase/message_send_progress.dart';
import 'package:myflutterapp/feature/message/usecase/message_store.dart';
import 'package:myflutterapp/feature/message/usecase/message_usecase.dart';

class MessageUseCaseImpl implements MessageUseCase {
  final ProviderRef<dynamic> ref;
  MessageUseCaseImpl(this.ref);

  @override
  Future<int> initialLoad() async {
    final repo = ref.read(messageRepositoryProvider);
    final messages = await repo.readQuery(offset: 0, limit: 20);

    final mine = messages.fold([] as List<MyMessageEntity>, (acc, current) {
      final status = current.status;
      if (!current.isMine || status == null) return acc;
      return [
        ...acc,
        MyMessageObject(
          id: current.id,
          text: current.text,
          createdAt: current.createdAt,
          status: status,
        ),
      ];
    });
    final myMessagesNotifier = ref.read(myMessagesProvider.notifier);
    myMessagesNotifier.add(mine);

    final ai = messages.fold([] as List<AiMessageEntity>, (acc, current) {
      if (current.isMine) return acc;
      return [
        ...acc,
        AiMessageObject(
          id: current.id,
          text: current.text,
          createdAt: current.createdAt,
        ),
      ];
    });
    final aiMessagesNotifier = ref.read(aiMessagesProvider.notifier);
    aiMessagesNotifier.add(ai);

    return messages.length;
  }

  @override
  Stream<MessageSendProgress> send(String question) async* {
    // repoに送信中として格納して状態に反映させる
    final repo = ref.read(messageRepositoryProvider);
    final myDao = await repo.create(question, true, MessageStatus.sending);
    final myMessagesNotifier = ref.read(myMessagesProvider.notifier);
    final myEntity = MyMessageObject(
      id: myDao.id,
      text: myDao.text,
      createdAt: myDao.createdAt,
      status: myDao.status,
    );
    myMessagesNotifier.add([myEntity]);
    yield MessageSendProgressSending(myEntity);

    // aiに質問を投げる
    final ask = ref.read(aiDogAskProvider);
    final establish = ref.read(clientChannelEstablisherProvider);
    final answer = await ask(question, establish);

    // 回答を得たので送信中から返答済みにする
    final aiDao = await repo.create(answer, false, null);
    final _ = await repo.update(myEntity.id, status: MessageStatus.replied);
    myMessagesNotifier
        .replace(myEntity.copyWith(status: MessageStatus.replied));

    final aiMessagesNotifier = ref.read(aiMessagesProvider.notifier);
    final aiEntity = AiMessageObject(
        id: aiDao.id, text: aiDao.text, createdAt: aiDao.createdAt);
    aiMessagesNotifier.add([aiEntity]);
  }
}
