import 'package:app/components/custom_button.dart';
import 'package:app/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    void signup() {}

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
                  //account creation message
                  Text(
                    "Let's Create an account for you!",
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
                  SizedBox(height: 10),

                  //confirm password Textfield
                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: "confirm password",
                      obscureText: true),
                  SizedBox(height: 25),

                  //login button
                  MyButton(onTap: signup, text: "Sign Up"),

                  //not a member mesasge
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already registared?"),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login Now",
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
