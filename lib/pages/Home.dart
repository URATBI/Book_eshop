import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:studentscopy/Auth_pages/login.dart';
import 'package:studentscopy/dep_books/depbooks.dart';
import 'package:studentscopy/pages/bookview.dart';

import '../search_books/Searchbooks.dart';
import './myprofile.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late User? _user;
  var userData;
  var books;

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
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Searchbooks()),
                );
              },
              icon: Icon(Icons.search_outlined)),
          SizedBox(
            width: 6.0,
          ),
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
            Container(
              height: 250,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 28, 210, 34),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 255, 255),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userData != null &&
                                userData.containsKey('profileImageUrl')
                            ? NetworkImage(userData['profileImageUrl'])
                            : AssetImage('assets/preimage.jpeg')
                                as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      userData != null ? userData['name'] ?? '' : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      userData != null ? userData['email'] ?? '' : '',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text("My Profile"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => myprofile()),
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
      body: SingleChildScrollView(
        child: Center(
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
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "First Years",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 28, 210, 34)),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Depbooks(year: '1')),
                          );
                        },
                        child: Text(
                          "See More",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 28, 210, 34)),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('books')
                    .where('year', isEqualTo: '1')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 28, 210, 34)),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    var documents = snapshot.data?.docs;
                    if (documents != null && documents.isNotEmpty) {
                      return SizedBox(
                        height: 320,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            var data =
                                documents[index].data() as Map<String, dynamic>;
                            String documentId = documents[index].id;
                            return buildBookCard(data, documentId);
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text('No books found'),
                      );
                    }
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Second Years",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 28, 210, 34)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Depbooks(year: '2')),
                        );
                      },
                      child: Text(
                        "See More",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 28, 210, 34)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('books')
                    .where('year', isEqualTo: '2')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 28, 210, 34)),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    var documents = snapshot.data?.docs;
                    if (documents != null && documents.isNotEmpty) {
                      return SizedBox(
                        height: 320,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            var data =
                                documents[index].data() as Map<String, dynamic>;
                            String documentId = documents[index].id;
                            return buildBookCard(data, documentId);
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text('No books found'),
                      );
                    }
                  }
                },
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Third Years",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 28, 210, 34)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Depbooks(year: '3')),
                        );
                      },
                      child: Text(
                        "See More",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 28, 210, 34)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('books')
                    .where('year', isEqualTo: '3')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 28, 210, 34)),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    var documents = snapshot.data?.docs;
                    if (documents != null && documents.isNotEmpty) {
                      return SizedBox(
                        height: 320,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            var data =
                                documents[index].data() as Map<String, dynamic>;
                            String documentId = documents[index].id;
                            return buildBookCard(data, documentId);
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text('No books found'),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookCard(Map<String, dynamic> bookData, String documentId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Bookview(bookid: documentId)),
        );
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        child: Container(
          padding: EdgeInsets.all(10),
          width: 178,
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage('${bookData!['bookpic']}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Book Title
              Text(
                bookData['bookname'].toString() ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              // Book Price
              Text(
                'Price: Rs ${bookData['price'].toString() ?? ''}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
