import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentscopy/Auth_pages/login.dart';

import '../user_data/data.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollnumberController = TextEditingController();
  final TextEditingController _deportmentController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _rollnumberController.dispose();
    _deportmentController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final User? user = userCredential.user;

      await _storeUserData(user!.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      print("Error during signup: $e");
    }
  }

  Future<void> _storeUserData(String userId) async {
    final userData = UserData(
      userId: userId,
      email: _emailController.text.trim(),
      name: _nameController.text.trim(),
      rollNumber: _rollnumberController.text.trim(),
      department: _deportmentController.text.trim(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('user_profiles')
          .doc(userId)
          .set(userData.toJson());
      print('User data stored successfully');
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 100.0,
          ),
          Center(
            child: Container(
              width: 150.0,
              height: 35.0,
              color: const Color.fromARGB(255, 28, 210, 34),
              child: const Center(
                child: Text(
                  "Sign-Up",
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
              child: Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.person_4_outlined,
                    size: 25.0,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'User Name',
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
              child: Row(
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
                      controller: _emailController,
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
              child: Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.book_outlined,
                    size: 25.0,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _rollnumberController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Roll Numder',
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
              child: Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.home_work_outlined,
                    size: 25.0,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _deportmentController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Deportment ex:(B-Tech-IT)',
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
              child: Row(
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
                      controller: _passwordController,
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
                      _signUp();
                    },
                    child: const Text(
                      'SignUp',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
