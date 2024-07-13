import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/message/usecase/message_usecase.dart';
import 'package:myflutterapp/feature/message/usecase/message_usecase_impl.dart';

final messageUseCaseProvider =
    Provider.autoDispose<MessageUseCase>((ref) => MessageUseCaseImpl(ref));
