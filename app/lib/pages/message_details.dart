import 'package:flutter/material.dart';

class MessageDetails extends StatefulWidget {
  final String encodedMessage;
  final String messageWithoutParity;
  final String stuffedMessage;
  final String message;
  const MessageDetails(
      {super.key,
      required this.encodedMessage,
      required this.messageWithoutParity,
      required this.stuffedMessage,
      required this.message});

  @override
  State<MessageDetails> createState() => _MessageDetailsState();
}

class _MessageDetailsState extends State<MessageDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Message: ${widget.message}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Stuffed Message: ${widget.stuffedMessage}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Message without parity: ${widget.messageWithoutParity}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Encoded Message: ${widget.encodedMessage}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
