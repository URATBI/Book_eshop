import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 100.0,
        ),
        const SizedBox(
          width: double.infinity,
          child: Text(
            "WELCOME YOU!!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              decorationStyle: TextDecorationStyle.dashed,
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
            color: const Color.fromARGB(255, 28, 210, 34),
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
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.email_outlined,
                  size: 25.0,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 35.0,
        ),
        Center(
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.lock_outline,
                  size: 25.0,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Center(
          widthFactor: 200.0,
          child: Container(
            width: 300.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Forget Password?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 28, 210, 34)),
                  ),
                  onPressed: () {
                    print('Login');
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
        const Center(
          child: Text(
            "or",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
        const Center(
          child: Text(
            "If you are new ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    ));
  }
}
