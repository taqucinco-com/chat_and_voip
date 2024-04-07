import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Logged in as: ${user.email}'),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement logout functionality
                    },
                    child: Text('Logout'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  // TODO: Implement login functionality
                },
                child: Text('Login'),
              ),
      ),
    );
  }
}

final userProvider = Provider<User?>((ref) {
  final auth = FirebaseAuth.instance;
  return auth.currentUser;
});
