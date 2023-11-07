import 'package:app/pages/chat_page.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instance of auth
  FirebaseAuth _auth = FirebaseAuth.instance;

  //sign-out
  void signout() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Page"),
        actions: [
          IconButton(
            onPressed: signout,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: _buildUserList(),
    );
  }

  //list of all users except logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //display all users except current user
    if (_auth.currentUser?.email != data['email']) {
      return ListTile(
        title: Text(
          data['email'],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverUserEmail: data['email'],
                recieverUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
