import 'package:app/components/chat_bubble.dart';
import 'package:app/components/custom_text_field.dart';
import 'package:app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserID;
  const ChatPage(
      {super.key,
      required this.recieverUserEmail,
      required this.recieverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messagecontroller = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String encodeMessage() {
    String message = _messagecontroller.text;
    String stuffedMessage = StuffMessage(message);
    String binaryMessage = stringToBinary(stuffedMessage);
    String finalEncodedMessage = evenParity(binaryMessage);
    return finalEncodedMessage;
  }

  String StuffMessage(String message) {
    String stuffedMessage;
    //search message for 'TRXA' and add 'TRXATRXA' in its place
    message.replaceAll('TRXA', 'TRXATRXA');
    //append 'TRXA' in the begining and end of message and store in stuffed message
    stuffedMessage = 'TRXA' + message + 'TRXA';
    return stuffedMessage;
  }

  String stringToBinary(String s) {
    int len = s.length;
    StringBuffer binary = StringBuffer();
    for (int i = 0; i < len; ++i) {
      int ch = s.codeUnitAt(i);
      for (int j = 7; j >= 0; --j) {
        if ((ch & (1 << j)) != 0) {
          binary.write("1");
        } else {
          binary.write("0");
        }
      }
    }
    return binary.toString();
  }

  //add a parity bot at the end of the message and make even parity
  String evenParity(String binaryMessage) {
    int count = 0;
    for (int i = 0; i < binaryMessage.length; i++) {
      if (binaryMessage[i] == '1') {
        count++;
      }
    }
    if (count % 2 == 0) {
      binaryMessage = binaryMessage + '0';
    } else {
      binaryMessage = binaryMessage + '1';
    }
    return binaryMessage;
  }

  void sendMesage() async {
    if (_messagecontroller.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.recieverUserID,
        encodeMessage(),
      );
      _messagecontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.recieverUserEmail),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
            SizedBox(
              height: 25,
            ),
          ],
        ));
  }

  //build message list

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.recieverUserID, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //remove last parity bit
    String removeParityBit(String message) {
      String withoutParityBit = message.substring(0, message.length - 1);
      return withoutParityBit;
    }

    String binaryToString(String binary) {
      int len = binary.length;
      String result = '';
      for (int i = 0; i < len; i += 8) {
        String byte = binary.substring(i, i + 8);
        int charCode = int.parse(byte, radix: 2);
        result = result + String.fromCharCode(charCode);
      }
      return result;
    }

    String removeStuffing(String message) {
      String unstuffedMessage;
      //remove 'TRXA' from the begining and end of message
      unstuffedMessage = message.replaceAll('TRXA', '');
      //remove 'TRXATRXA' from the message
      unstuffedMessage.replaceAll('TRXATRXA', 'TRXA');
      return unstuffedMessage;
    }

    String decodeMessage(String binaryMessage) {
      String withoutParityBit = removeParityBit(binaryMessage);
      String stringMessage = binaryToString(withoutParityBit);
      String decodedMessage = removeStuffing(stringMessage);
      return decodedMessage;
    }

    //allign the sender mesage to left and reciever message to left
    var alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerLeft
        : Alignment.centerRight;

    return Container(
      alignment: alignment,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        mainAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Text(
            data['senderEmail'],
          ),
          SizedBox(
            height: 5,
          ),
          ChatBubble(
            message: decodeMessage(data['message']),
            //message: data['message'],
            color: (data['senderId'] == _auth.currentUser!.uid)
                ? Colors.blue.shade400
                : Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
                controller: _messagecontroller,
                hintText: "Enter Message",
                obscureText: false),
          ),
          IconButton(
            onPressed: sendMesage,
            icon: Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
