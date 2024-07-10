import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/component/chat_tile.dart';
import 'package:myflutterapp/feature/aidog/aidog_provider.dart';
import 'package:myflutterapp/page/home/components/message_bar.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ask = ref.read(aiDogAskProvider);

    final myMessages = useState<List<(DateTime date, String word)>>([]);
    final dogMessages = useState<List<(DateTime date, String word)>>([]);
    final isSending = useState(false);
    final allMessages = [...myMessages.value, ...dogMessages.value]
      ..sort((a, b) => a.$1.compareTo(b.$1));

    final scrollController = useScrollController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (allMessages.isNotEmpty) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
      return null;
    }, [allMessages]);

    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return const Text("Error");
    };
    FlutterError.onError = (details) {
      if (kDebugMode) print(details);
    };

    final messageList = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => primaryFocus?.unfocus(),
      child: Scrollbar(
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          itemCount: allMessages.length + (isSending.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (isSending.value && index >= allMessages.length) {
              return ChatTile(message: (DateTime.now(), '...'), isMine: false);
            }
            final message = allMessages[index];
            final isMine = myMessages.value.contains(message);
            return ChatTile(message: message, isMine: isMine);
          },
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          Expanded(child: messageList),
          MessageBar(
            onSubmit: (text) async {
              myMessages.value = [...myMessages.value, (DateTime.now(), text)];
              try {
                isSending.value = true;
                final answer = await ask(text);
                final answerWithEmoji = '$answer \u{1F436}';
                dogMessages.value = [
                  ...dogMessages.value,
                  (DateTime.now(), answerWithEmoji),
                ];
              } finally {
                isSending.value = false;
              }
            },
          ),
        ],
      ),
    );
  }
}
