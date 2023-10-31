import 'package:app/components/custom_button.dart';
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
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                //logo
                Icon(
                  Icons.message,
                  size: 100,
                ),
                SizedBox(height: 50),
                //welcome back message
                Text(
                  "Welcome back. You've been missed!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 25),

                //emial textfield
                MyTextField(
                    controller: emailController,
                    hintText: "email",
                    obscureText: false),

                SizedBox(height: 10),

                //password textfield

                MyTextField(
                    controller: passwordController,
                    hintText: "password",
                    obscureText: true),
                SizedBox(height: 25),

                //login button
                MyButton(onTap: () {}, text: "Sign In"),

                //not a member mesasge
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?"),
                    SizedBox(width: 4),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Register Now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
