import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/message/usecase/message_usecase.dart';
import 'package:myflutterapp/feature/message/usecase/message_interactor.dart';

final messageUseCaseProvider =
    Provider.autoDispose<MessageUseCase>((ref) => MessageInteractor(ref));
