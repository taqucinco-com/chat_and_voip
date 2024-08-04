import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/auth/auth_provider.dart';
import 'package:myflutterapp/page/settings/components/settings_table_list.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authFacade = ref.watch(authFacadeProvider);

    final googleLoginButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () async => await authFacade.signInWithGoogle(),
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(const Size(180, 40)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/google.svg',
                width: 24.0,
                height: 24.0,
              ),
              const SizedBox(width: 16.0),
              Text(
                'Sign in with Google',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ),
        const SizedBox(width: 16.0),
      ],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 32.0),
          child: Text(
            "このアプリでAI犬から教えてもらうにはログインが必要です。",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        googleLoginButton,
        const SizedBox(height: 56.0),
        const SettingsTableList(),
      ],
    );
  }
}
