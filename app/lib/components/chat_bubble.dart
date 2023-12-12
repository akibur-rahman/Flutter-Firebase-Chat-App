import 'package:app/pages/message_details.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  final encodedMessage;
  final messageWithoutParity;
  final stuffedMessage;
  final decodedMessage;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.color,
      this.encodedMessage,
      this.messageWithoutParity,
      this.stuffedMessage,
      this.decodedMessage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: color == Colors.blue.shade400 ? Colors.white : Colors.black,
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageDetails(
                encodedMessage: encodedMessage,
                messageWithoutParity: messageWithoutParity,
                stuffedMessage: stuffedMessage,
                message: message),
          ),
        );
      },
    );
  }
}
