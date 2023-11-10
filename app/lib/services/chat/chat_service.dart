import 'package:app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  //get intense of auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //senging message
  Future<void> sendMessage(String reciverId, String message) async {
    //get current user info'
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderId: currentUserID,
        senderEmail: currentUserEmail,
        recieverId: reciverId,
        message: message,
        timestamp: timestamp);
    //construct chat room id for the current user and also for reciever id
    List<String> ids = [currentUserID, reciverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    //add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //getting message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct chat room id from users ids(sorted ti ensure it matches the id used when sending messages )
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
