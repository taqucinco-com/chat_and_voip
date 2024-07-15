import 'package:myflutterapp/feature/message/usecase/message_send_progress.dart';

abstract interface class MessageUseCase {
  /// 今までの会話の初回ロードを行いメッセージの総数[int]を返す
  Future<int> initialLoad();

  /// AIに質問を送信し、その進捗状況を購読する
  Stream<MessageSendProgress> send(String question);
}
