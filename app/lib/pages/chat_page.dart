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
    String stuffedMessage = message;
    // search message for 'TRXA' and add 'HHHTRXA' in its place
    stuffedMessage = stuffedMessage.replaceAll('TRXA', 'HHHTRXA');
    // append 'TRXA' in the beginning and end of message and store in stuffed message
    stuffedMessage = 'TRXA' + stuffedMessage + 'TRXA';
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

  //add parity bit at the end of each byte make even parity
  String evenParity(String binaryMessage) {
    String finalEncodedMessage = '';
    String parityBit = '';
    String byte = '';
    int count = 0;
    int len = binaryMessage.length;
    for (int i = 0; i < len; i += 8) {
      byte = binaryMessage.substring(i, i + 8);
      for (int j = 0; j < 8; j++) {
        if (byte[j] == '1') {
          count++;
        }
      }
      if (count % 2 == 0) {
        parityBit = '0';
      } else {
        parityBit = '1';
      }
      finalEncodedMessage = finalEncodedMessage + byte + parityBit;
      count = 0;
    }
    return finalEncodedMessage;
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
    String withoutParityBit = '';
    String stringMessage = '';
    String decodedMessage = '';

    //remove last parity bit
    String removeParityBit(String binaryMessage) {
      String withoutParityBit = '';
      int len = binaryMessage.length;
      for (int i = 0; i < len; i += 9) {
        String byte = binaryMessage.substring(i, i + 8);
        withoutParityBit = withoutParityBit + byte;
      }
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
      String unstuffedMessage = message;
      // replace 'HHHTRXA' with 'TRXA'
      unstuffedMessage = unstuffedMessage.replaceAll('HHHTRXA', 'TRXA');
      // remove 'TRXA' from the beginning and end of message only if they are standalone
      unstuffedMessage =
          unstuffedMessage.substring(4, unstuffedMessage.length - 4);

      return unstuffedMessage;
    }

    String decodeMessage(String binaryMessage) {
      withoutParityBit = removeParityBit(binaryMessage);
      stringMessage = binaryToString(withoutParityBit);
      decodedMessage = removeStuffing(stringMessage);
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
            encodedMessage: data['message'],
            messageWithoutParity: withoutParityBit,
            stuffedMessage: stringMessage,
            decodedMessage: decodedMessage,
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
