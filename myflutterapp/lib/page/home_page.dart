// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/component/chat_tile.dart';
import 'package:myflutterapp/feature/greeter/greeter_repository.dart';
import 'package:myflutterapp/src/generated/helloworld.pbgrpc.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myMessages = useState<List<(DateTime date, String word)>>([]);
    final yourMessages = useState<List<(DateTime date, String word)>>([]);
    final allMessages = [...myMessages.value, ...yourMessages.value]
      ..sort((a, b) => a.$1.compareTo(b.$1));

    final requestController =
        useMemoized(() => StreamController<HelloRequest>());
    final responseStream =
        useMemoized(() => establishChat(requestController.stream));
    final scrollController = useScrollController();
    final textEditingController = useTextEditingController();

    useEffect(() {
      responseStream.handleError((e) {
        print(e);
      });
      final subscription = responseStream.listen((response) {
        yourMessages.value = [
          ...yourMessages.value,
          (DateTime.now(), response.message)
        ];
      });
      return subscription.cancel;
    }, []);

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
      print(details);
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('会話'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scrollbar(
          controller: scrollController,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            itemCount: allMessages.length,
            itemBuilder: (context, index) {
              final message = allMessages[index];
              final isMine = myMessages.value.contains(message);
              return ChatTile(message: message, isMine: isMine);
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: textEditingController,
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
              onPressed: () {
                final word = textEditingController.text;
                requestController.sink.add(HelloRequest()..name = word);
                myMessages.value = [
                  ...myMessages.value,
                  (DateTime.now(), word)
                ];
                textEditingController.clear();
              },
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
