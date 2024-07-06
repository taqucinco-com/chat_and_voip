import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/auth/auth_facade.dart';
import 'package:myflutterapp/page/settings/components/settings_table_list.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider);
    final authManager = ref.watch(authManagerProvider);

    final photoURL = user.value?.photoURL;
    final userName = user.value?.displayName ?? 'ユーザー';

    final userIcon = photoURL != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              photoURL,
              width: 80.0,
              height: 80.0,
            ),
          )
        : const Icon(Icons.account_circle, size: 80.0);

    final upper = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              userIcon,
              const SizedBox(width: 24),
              Text(
                '$userNameさん',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ],
          ),
        ),
        const SettingsTableList(),
        ElevatedButton(
          onPressed: () async => await authManager.getIdToken(),
          child: const Text('idToken'),
        ),
      ],
    );

    final lower = Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        onPressed: () async => await authManager.deleteAccount(),
        child: Text(
          'アカウント削除',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [upper, lower],
    );
  }
}
