import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatTile extends StatelessWidget {
  final (DateTime date, String word) message;
  final bool isMine;

  const ChatTile({super.key, required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: isMine
            ? const EdgeInsets.only(
                left: 80.0, right: 8.0, top: 8.0, bottom: 8.0)
            : const EdgeInsets.only(
                left: 8.0, right: 80.0, top: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
          color: isMine ? Colors.blue[200] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(message.$2),
            const SizedBox(height: 8.0),
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
