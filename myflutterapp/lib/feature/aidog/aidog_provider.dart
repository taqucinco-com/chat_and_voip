import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/aidog/aidog_controller.dart';
import 'package:myflutterapp/feature/aidog/aidog_controller_impl.dart';

final aiDogAskProvider = Provider.autoDispose<AiDogAskInterface>((ref) {
  return askFunc;
});
