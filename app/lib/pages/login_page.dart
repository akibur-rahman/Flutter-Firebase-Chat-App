import 'package:app/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //logo
              Icon(
                Icons.message,
                size: 80,
              ),

              //welcome back message
              Text(
                "Welcome back. You've been missed!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              //emial textfield
              MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false),

              //password textfield

              //not a member mesasge
            ],
          ),
        ),
      ),
    );
  }
}
