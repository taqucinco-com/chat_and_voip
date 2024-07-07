import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MessageBar extends HookConsumerWidget {
  final Future<void> Function(String) onSubmit;

  const MessageBar({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: textEditingController,
              maxLines: 3,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'メッセージを入力',
              ),
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.white,
            ),
            onPressed: () async {
              final text = textEditingController.text;
              textEditingController.clear();
              onSubmit(text);
            },
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
