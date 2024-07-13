import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ulid/ulid.dart';

typedef UlidGenerator = String Function();
final ulidGeneratorProvider = Provider<UlidGenerator>((ref) {
  return () => Ulid().toUuid();
});
