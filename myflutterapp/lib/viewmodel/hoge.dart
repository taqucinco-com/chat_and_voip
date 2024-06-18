import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class HogeNotifier extends FamilyAsyncNotifier<int, int> {

  @override
  Future<int> build(int value) async {
    return 0 + value;
  }

  Future<void> add(int added) async {
    update((date) async {
      state = const AsyncValue.loading();
      return date + added;
    });
  }
}

final hogeProvider = AsyncNotifierProvider.autoDispose.family<HogeNotifier, int, int>(HogeNotifier.new);