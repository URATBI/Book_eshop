import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentscopy/EditProfile/editprofile.dart';
import 'package:studentscopy/pages/Home.dart';

import '../get_data/getdata.dart';

class myprofile extends StatefulWidget {
  @override
  State<myprofile> createState() => _myprofileState();
}

class _myprofileState extends State<myprofile> {
  late User? _user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    try {
      GetData getDataInstance = GetData();
      final fetchedData = await getDataInstance.getDataForUser();
      setState(() {
        userData = fetchedData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  double containerWidthPercentage = 0.95;

  File? _imageFile;
  String? _imageUrl;

  final picker = ImagePicker();

  Future<void> uploadImage() async {
    try {
      if (_imageFile != null) {
        String fileName = userData!['name'].toString();
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference =
            storage.ref().child('user_profiles').child('$fileName.jpg');

        UploadTask uploadTask = storageReference.putFile(_imageFile!);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl;
        });

        print('Image uploaded successfully. URL: $_imageUrl');

        await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(userData!['userId'])
            .update({'profileImageUrl': _imageUrl});
        await getdata();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => myprofile(),
            settings: RouteSettings(name: 'MyProfilePage'),
          ),
        );
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userData != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Center(
                    child: Container(
                      width: 150.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 28, 210, 34),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "My Profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 28, 210, 34),
                          width: 3,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: userData != null &&
                                userData!.containsKey('profileImageUrl')
                            ? NetworkImage(userData!['profileImageUrl'])
                            : AssetImage('assets/preimage.jpeg')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      '${userData!['name']}',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      '${userData!['email']}',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: const Color.fromARGB(255, 68, 68, 68)),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  userData != null && userData!.containsKey('profileImageUrl')
                      ? SizedBox(
                          height: 0,
                        )
                      : Center(
                          child: SizedBox(
                            height: 20.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 28, 210, 34)),
                              ),
                              onPressed: () {
                                getImage();
                              },
                              child: const Text(
                                'Add photo',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                        ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Student Details",
                          style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 28, 210, 34)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => editprofile()),
                            );
                          },
                          child: Text(
                            "edit profile",
                            style: TextStyle(
                                fontSize: 15.0,
                                color: const Color.fromARGB(255, 28, 210, 34)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...userData!.entries
                            .where((entry) =>
                                entry.key != 'profileImageUrl' &&
                                entry.key != 'email')
                            .map((entry) {
                          final key =
                              '${entry.key[0].toUpperCase()}${entry.key.substring(1)}';
                          return Text(
                            '$key: ${entry.value}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          );
                        }).map(
                          (textWidget) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: textWidget,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 28, 210, 34)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: const Text(
                      'Back',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
