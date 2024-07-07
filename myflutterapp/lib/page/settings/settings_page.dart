import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/auth/auth_provider.dart';
import 'package:myflutterapp/page/settings/screen/login_screen.dart';
import 'package:myflutterapp/page/settings/screen/settings_screen.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider);
    final authManager = ref.watch(authManagerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (user.value != null)
            TextButton(
              onPressed: () async => await authManager.signOut(),
              child: Text(
                'ログアウト',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
        ],
      ),
      body: Center(
        child:
            user.value != null ? const SettingsScreen() : const LoginScreen(),
      ),
    );
  }
}
