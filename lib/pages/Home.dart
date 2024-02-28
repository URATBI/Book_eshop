import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentscopy/Auth_pages/login.dart';

import './myprofile.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late User? _user;
  var userData;

  Future<void> checkUser() async {
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkUser();
    _initFunction();
  }

  Future<void> _initFunction() async {
    await _getDataForUser();
  }

  Future<void> _getDataForUser() async {
    try {
      User? users = _auth.currentUser;
      if (users != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(users!.uid)
            .get();

        if (userSnapshot.exists) {
          setState(() {
            userData = userSnapshot.data();
          });

          print('User data: $userData');
        } else {
          print('No such document!');
        }
      } else {
        print('User is not signed in!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      print('Error occurred while logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students copy',
          style: TextStyle(fontSize: 20.0),
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            child: Image(
              image: AssetImage('assets/logo3.png'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 28, 210, 34),
              ),
              child: Text(
                userData != null ? userData['name'] ?? '' : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
            ListTile(
              title: Text("My Profile"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => myprofile(userData: userData)),
                );
              },
            ),
            ListTile(
              title: Text(userData != null ? userData['rollNumber'] ?? '' : ''),
              onTap: () {},
            ),
            ListTile(
              title: Text(userData != null ? userData['department'] ?? '' : ''),
              onTap: () {},
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: 250,
                child: Image(
                  image: AssetImage('assets/bookimage.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text('Welcome, ${_user!.email}'),
          ],
        ),
      ),
    );
  }
}
