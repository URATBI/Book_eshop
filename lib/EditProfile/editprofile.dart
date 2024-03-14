import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentscopy/pages/myprofile.dart';

class editprofile extends StatefulWidget {
  const editprofile({Key? key}) : super(key: key);

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  var userData;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();

  final TextEditingController _numberController = TextEditingController();
  String? _selectedyear;

  List<String> _dropdownItemsyear = ['1', '2', '3', '4'];
  String? _selectedsem;

  List<String> _dropdownItemsSem = ['1', '2', '3', '4', '5', '6', '7', '8'];

  Future<void> checkUser() async {
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _getDataForUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          setState(() {
            userData = userSnapshot.data();
            _nameController.text = userData['name'] ?? '';
            _departmentController.text =
                userData != null && userData.containsKey('department')
                    ? userData['department']
                    : '';

            _rollController.text =
                userData != null && userData.containsKey('rollNumber')
                    ? userData['rollNumber']
                    : '';
            _ageController.text =
                userData != null && userData.containsKey('age')
                    ? userData['age']
                    : '';
            _numberController.text =
                userData != null && userData.containsKey('number')
                    ? userData['number']
                    : '';
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

  Future<void> save() async {
    if (_nameController.text.isNotEmpty &&
        _departmentController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _selectedyear != null &&
        _selectedyear!.isNotEmpty &&
        _selectedsem != null &&
        _selectedsem!.isNotEmpty &&
        _numberController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(userData!['userId'])
            .update({
          'age': _ageController.text.trim(),
          'year': _selectedyear,
          'name': _nameController.text.trim(),
          'department': _departmentController.text.trim(),
          'rollNumber': _rollController.text.trim(),
          'number': _numberController.text.trim(),
          'semester': _selectedsem
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => editprofile()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User data updated successfully!!'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ),
          ),
        );
      } catch (error) {
        print('Error updating user profile: $error');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Empty fields'),
            content: Text('Fill the Empty field'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => editprofile(),
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
  void initState() {
    super.initState();
    checkUser();
    _initializeSelectedYear();
  }

  Future<void> _initializeSelectedYear() async {
    await _getDataForUser();
    setState(() {
      _selectedyear = userData != null && userData.containsKey('year')
          ? userData['year']
          : _dropdownItemsyear.last;
      _selectedsem = userData != null && userData.containsKey('semester')
          ? userData['semester']
          : _dropdownItemsSem.last;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                            "Edit Profile",
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
                                  userData.containsKey('profileImageUrl')
                              ? NetworkImage(userData['profileImageUrl'])
                              : AssetImage('assets/preimage.jpeg')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: SizedBox(
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
                            'Edit photo',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Student Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                              Container(
                                width: 230,
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
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Name',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reg NO",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                              Container(
                                width: 230,
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
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _rollController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'rollNumber',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Student Age",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                              Container(
                                width: 230,
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
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _ageController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Age',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Department",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                              Container(
                                width: 230,
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
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _departmentController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'department',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Year",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0),
                                    ),
                                    Container(
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10.0),
                                          Expanded(
                                            child: DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              value: _selectedyear,
                                              items: _dropdownItemsyear
                                                  .map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  int index = _dropdownItemsyear
                                                      .indexOf(newValue!);
                                                  _selectedyear =
                                                      _dropdownItemsyear[index];
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sem",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0),
                                    ),
                                    Container(
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10.0),
                                          Expanded(
                                            child: DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              value: _selectedsem,
                                              items: _dropdownItemsSem
                                                  .map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  int index = _dropdownItemsSem
                                                      .indexOf(newValue!);
                                                  _selectedsem =
                                                      _dropdownItemsSem[index];
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Moblie No",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                              Container(
                                width: 230,
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
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _numberController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Moblie Number',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
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
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 28, 210, 34)),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => myprofile()),
                                );
                              },
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 28, 210, 34)),
                              ),
                              onPressed: () {
                                save();
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
              : Center(
                  child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 28, 210, 34)),
                )),
    );
  }
}
