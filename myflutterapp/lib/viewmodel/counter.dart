import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter.g.dart';

class CounterNotifier extends CountableNotifier {
  @override
  int build() {
    return 0;
  }

  @override
  void increment() {
    state = state + 1;
  }
}

abstract class CountableNotifier extends Notifier<int> {
  void increment();
}

final counterProvider = NotifierProvider<CountableNotifier, int>(() {
  return CounterNotifier();
});


// abstract class Incrementable extends Notifier<int> {
//   void increment();
// }

// @riverpod
// class Fuga extends _$Fuga implements CountableNotifier {
//   @override
//   int build() {
//     return 0;
//   }

//   @override
//   void increment() {
//     state = state + 1;
//   }
// }
