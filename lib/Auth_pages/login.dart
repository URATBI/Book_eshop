import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 100.0,
        ),
        Container(
          width: double.infinity,
          child: const Text(
            "WELCOME YOU!!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              decorationStyle:
                  TextDecorationStyle.dashed, // Set decoration style
              decorationThickness: 5.0,
            ),
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Center(
          child: Container(
            width: 150.0,
            height: 35.0,
            color: Color.fromARGB(255, 28, 210, 34),
            child: const Center(
              child: Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
        Center(
          child: Container(
            width: 190.0,
            color: Colors.blue,
            child: Row(
              children: [
                Icon(Icons.person), // Icon on the left side
                SizedBox(width: 10.0), // Spacer between icon and text field
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
