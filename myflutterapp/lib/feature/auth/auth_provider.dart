import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/auth/auth_facade.dart';
import 'package:myflutterapp/main.dart';

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  return auth.authStateChanges();
});

final authFacadeProvider = Provider.autoDispose<AuthorizationFacade>((ref) {
  return AuthorizationFacadeImpl();
});
