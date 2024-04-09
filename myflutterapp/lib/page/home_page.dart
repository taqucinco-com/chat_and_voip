// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myMessages = useState<List<(DateTime date, String word)>>([]);
    final yourMessages = useState<List<(DateTime date, String word)>>([]);
    final allMessages = [...myMessages.value, ...yourMessages.value]
      ..sort((a, b) => a.$1.compareTo(b.$1));
    final controller = useScrollController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (allMessages.isNotEmpty) {
          controller.animateTo(
            controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    }, [allMessages]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('会話'),
      ),
      body: Scrollbar(
        controller: controller,
        child: ListView.builder(
          controller: controller,
          scrollDirection: Axis.vertical,
          itemCount: allMessages.length,
          itemBuilder: (context, index) {
            final message = allMessages[index];
            final isMine = myMessages.value.contains(message);
            return _createWord(message, isMine);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                myMessages.value = [
                  ...myMessages.value,
                  (DateTime.now(), 'my comment')
                ];
              },
              child: const Text('Mine'),
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
                yourMessages.value = [
                  ...yourMessages.value,
                  (DateTime.now(), 'your comment')
                ];
              },
              child: const Text('Yours'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createWord((DateTime date, String word) message, bool isMine) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: isMine
            ? const EdgeInsets.only(
                left: 56.0, right: 8.0, top: 4.0, bottom: 4.0)
            : const EdgeInsets.only(
                left: 8.0, right: 56.0, top: 4.0, bottom: 4.0),
        decoration: BoxDecoration(
          color: isMine ? Colors.blue[200] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(message.$2),
            const SizedBox(height: 4.0),
            Text(
              DateFormat('yyyy-MM-dd hh:mm:ss').format(message.$1),
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
