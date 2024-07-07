import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/aidog/aidog_repository.dart';

final aiDogAskProvider = Provider.autoDispose<AiDogAskInterface>((ref) {
  return askFunc;
});
