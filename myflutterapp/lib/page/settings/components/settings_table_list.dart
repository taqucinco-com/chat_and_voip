import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsTableList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    createListItem({
      required String text,
      required IconData iconData,
      VoidCallback? onTap,
    }) =>
        Row(
          children: [
            Icon(
              iconData,
              color: Theme.of(context).colorScheme.secondary,
            ),
            TextButton(
              onPressed: onTap,
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            )
          ],
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          createListItem(
            text: '利用規約',
            iconData: Icons.newspaper,
            onTap: () async {
              final url =
                  Uri.parse('https://taqucinco-com.github.io/chat_and_voip/');
              if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                throw Exception('Could not launch browser');
              }
            },
          ),
          const Divider(),
          createListItem(
            text: 'ライセンス',
            iconData: Icons.credit_score,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "バージョン情報 x.y.z",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
