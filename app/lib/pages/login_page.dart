import 'package:app/components/custom_button.dart';
import 'package:app/components/custom_text_field.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> signin() async {
      //auth service
      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        await authService.signIn(emailController.text, passwordController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: SingleChildScrollView(
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
                  MyButton(onTap: signin, text: "Sign In"),

                  //not a member mesasge
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?"),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
