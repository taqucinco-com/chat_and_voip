// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/auth/auth_proxy.dart';
import 'package:myflutterapp/viewmodel/counter.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: Center(
        child: user.value != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Logged in as: ${user.value?.email}'),
                  ElevatedButton(
                    onPressed: () async => await getIdToken(),
                    child: const Text('idToken'),
                  ),
                  ElevatedButton(
                    onPressed: () async => await signOut(),
                    child: const Text('Logout'),
                  ),
                  ElevatedButton(
                    onPressed: () async => await deleteAccount(),
                    child: const Text('Delete Account'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () => signInWithGoogle(),
                child: const Text('Login'),
              ),
      ),
    );
  }
}
