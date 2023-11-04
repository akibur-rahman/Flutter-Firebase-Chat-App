import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  //instense of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign user in
  Future signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } catch (e) {
      print(e.toString());
    }
  }

  //sign user out

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  //create user account
  Future<UserCredential> signUpwithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
