import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentscopy/pages/Home.dart';

class myprofile extends StatefulWidget {
  final Map<String, dynamic>? userData;

  myprofile({this.userData});

  @override
  State<myprofile> createState() => _myprofileState();
}

class _myprofileState extends State<myprofile> {
  @override
  Widget build(BuildContext context) {
    double containerWidthPercentage = 0.95;

    File? _imageFile;
    String? _imageUrl;

    final picker = ImagePicker();

    Future<void> uploadImage() async {
      try {
        if (_imageFile != null) {
          String fileName = widget.userData!['name'].toString();
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
              .doc(widget.userData!['userId'])
              .update({'profileImageUrl': _imageUrl});
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

    return Scaffold(
      appBar: AppBar(
          title: Text('My Profile'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          )),
      body: widget.userData != null
          ? Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: containerWidthPercentage,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                                '${widget.userData!['profileImageUrl']}'),
                          ),
                          Container(
                            width: 190,
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${widget.userData!['name']}',
                                    style: TextStyle(fontSize: 20.0),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${widget.userData!['email']}',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: const Color.fromARGB(
                                            255, 94, 94, 94)),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40.0,
                    ),
                    SizedBox(
                      height: 20.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
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
                  ],
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
