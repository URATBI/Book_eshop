import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    _user = _auth.currentUser;
    if (_user != null) {
      return FirebaseFirestore.instance
          .collection('user_profiles')
          .doc(_user!.uid)
          .snapshots();
    } else {
      return Stream.empty();
    }
  }
}

class AddToCard extends StatefulWidget {
  const AddToCard({Key? key}) : super(key: key);

  @override
  State<AddToCard> createState() => _AddToCardState();
}

class _AddToCardState extends State<AddToCard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Cards"),
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.all(0),
          child: Container(
            height: 60.0,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 60.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  size: 27,
                                  Icons.currency_rupee_outlined,
                                  color: Color.fromARGB(255, 39, 116, 20),
                                ),
                                Text(
                                  '400',
                                  style: TextStyle(fontSize: 23),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: Icon(
                                    size: 15,
                                    Icons.info_outlined,
                                    color: const Color.fromARGB(
                                        255, 101, 101, 101),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 135, 255, 121),
                            ),
                            height: 40,
                            child: Center(
                              child: Text(
                                "Place Order",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 45, 86, 7),
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          height: 60,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: GetData().getUserDataStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              if (snapshot.data == null || !snapshot.data!.exists) {
                return Center(
                  child: Text('No data found'),
                );
              } else {
                var userData = snapshot.data!.data();
                var favoriteBooks = userData!['fav_book'] as List<dynamic>;
                return ListView.builder(
                  itemCount: favoriteBooks.length,
                  itemBuilder: (context, index) {
                    return buildBookCard(favoriteBooks[index].toString());
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget buildBookCard(String documentId) {
    return GestureDetector(
      onTap: () {},
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .doc(documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            var bookData = snapshot.data?.data() as Map<String, dynamic>?;

            if (bookData != null) {
              int quantity = 0;
              return Center(
                child: FractionallySizedBox(
                  widthFactor: 0.95,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 141, 141, 141),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        //padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 120,
                                  height: 170,
                                  child:
                                      Image.network('${bookData['bookpic']}'),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  height: 170,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 200,
                                          child: Text(
                                            '${bookData['bookname']}',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 85, 85, 85),
                                                fontSize: 18),
                                          )),
                                      Text(
                                        '${bookData['department'].join(' ')}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 85, 85, 85),
                                            fontSize: 15),
                                      ),
                                      Text(
                                        '${bookData['reg']}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 85, 85, 85),
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 120,
                                  height: 33.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (quantity > 0) {
                                              quantity--;
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color.fromARGB(
                                                255, 255, 147, 147),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.remove,
                                              color: const Color.fromARGB(
                                                  255, 214, 2, 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$quantity',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            quantity++;
                                          });
                                        },
                                        child: Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color.fromARGB(
                                                255, 139, 255, 119),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Color.fromARGB(
                                                  255, 78, 187, 4),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  width: 200,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 35.0,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromARGB(
                                                255, 218, 218, 218),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Price',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 79, 79, 79)),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Icon(
                                              Icons.currency_rupee_outlined,
                                              color: Color.fromARGB(
                                                  255, 55, 114, 16),
                                            ),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            Text(
                                              '${bookData['price']}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete_outlined,
                                            color: Color.fromARGB(
                                                255, 255, 111, 111),
                                          ),
                                          Text(
                                            'Remove',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 105, 105, 105),
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 141, 141, 141),
                                          width: 1.0,
                                        ),
                                        right: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 141, 141, 141),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    height: 40,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.save_outlined,
                                            color: const Color.fromARGB(
                                                255, 105, 105, 105),
                                          ),
                                          Text(
                                            'Save for Later',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 105, 105, 105),
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 141, 141, 141),
                                          width: 1.0,
                                        ),
                                        right: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 141, 141, 141),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            color: Color.fromARGB(
                                                255, 159, 255, 75),
                                            Icons.bolt_outlined,
                                          ),
                                          Text(
                                            'Buy this Now',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 105, 105, 105),
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 141, 141, 141),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('No book found with ID: $documentId'),
              );
            }
          }
        },
      ),
    );
  }
}
