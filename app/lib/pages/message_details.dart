import 'package:flutter/material.dart';

class MessageDetails extends StatefulWidget {
  const MessageDetails({super.key});

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
        child: Column(
          children: [
            Text('Message Details'),
          ],
        ),
      ),
    );
  }
}
