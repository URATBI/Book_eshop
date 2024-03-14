import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentscopy/dep_books/depbooks.dart';

class Bookview extends StatefulWidget {
  final String bookid;

  const Bookview({required this.bookid});

  @override
  State<Bookview> createState() => _BookviewState();
}

class _BookviewState extends State<Bookview> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var bookData;
  num price = 0;
  var bookcount = 1;
  @override
  void initState() {
    super.initState();
    _getDataForUser();
  }

  Future<void> _getDataForUser() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('books')
          .doc(widget.bookid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          bookData = userSnapshot.data();
          price = bookData['price'];
        });

        print('User data: $bookData');
      } else {
        print('No such document!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void addcountbook() {
    setState(() {
      bookcount++;
      price += bookData['price'];
    });
  }

  Future<void> _addToCart() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(user.uid)
            .update({
          'fav_book': FieldValue.arrayUnion(['${widget.bookid}'])
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to cart'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      print('Error adding book to favorites: $e');
    }
  }

  void removecountbook() {
    if (bookcount > 1) {
      setState(() {
        bookcount = bookcount - 1;
        price -= bookData['price'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.all(0),
          child: Container(
            height: 60.0,
            child: Row(
              children: [
                Expanded(
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: GestureDetector(
                      onTap: () {
                        _addToCart();
                      },
                      child: Container(
                        height: 60.0,
                        child: Center(
                            child: Text(
                          'Add to Card',
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500),
                        )),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Color.fromARGB(255, 28, 210, 34),
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: GestureDetector(
                        onTap: () {
                          // Add your onTap logic here
                        },
                        child: Container(
                          height: 60.0,
                          child: Row(
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              Text(
                                'Buy Now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          height: 60,
        ),
        body: bookData != null
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Center(
                      child: Container(
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          child: Text(
                            "${bookData['bookname']}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 28, 210, 34)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Container(
                        height: 300.0,
                        width: 230.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(
                                255, 141, 141, 141), // Set border color here
                            width: 2.0, // Set border width here
                          ),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage('${bookData!['bookpic']}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Container(
                        color: const Color.fromARGB(255, 233, 233, 233),
                        height: 2.5,
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Container(
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: Text(
                            '${bookData['bookname']} includes ${bookData['department'].join(', ')} departments, all falling under the ${bookData['year']} year, ${bookData['sem']} semester, governed by the ${bookData['reg']} regulations.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Container(
                        height: 63,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(
                                255, 218, 218, 218), // Set border color here
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 28, 210, 34),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Icon(
                                            Icons.sell,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Center(
                                            child: Text(
                                              "Price",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      children: [
                                        Icon(Icons.currency_rupee_sharp),
                                        Text(
                                          '${price.toString()}',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  )
                                ],
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
                                        removecountbook();
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
                                      '${bookcount}',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addcountbook();
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
                                            color:
                                                Color.fromARGB(255, 78, 187, 4),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 30.0,
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                            child: Row(
                          children: [
                            Container(
                              height: 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 192, 251, 129),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Icon(
                                    Icons.av_timer,
                                    color: Color.fromARGB(255, 8, 218, 1),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    'Last book in Stack',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            Color.fromARGB(255, 59, 134, 18)),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Container(
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: Container(
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Book Details',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.info_outline,
                                ),
                              ],
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
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 218, 218, 218),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: 300,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bookname',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 130, 130, 130)),
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        '${bookData['bookname']}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromARGB(
                                                255, 130, 130, 130)),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Department',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 130, 130, 130)),
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        '${bookData['department'].join('  ')}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromARGB(
                                                255, 130, 130, 130)),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Year',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 130, 130, 130)),
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        '${bookData['year']}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromARGB(
                                                255, 130, 130, 130)),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Semmester',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 130, 130, 130)),
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        '${bookData['sem']}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromARGB(
                                                255, 130, 130, 130)),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Regulation',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 130, 130, 130)),
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        '${bookData['reg']}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromARGB(
                                                255, 130, 130, 130)),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Recommended",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 62, 62, 62)),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.recommend_outlined,
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Depbooks(year: '${bookData['year']}')),
                              );
                            },
                            child: Text(
                              "See More",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 52, 52, 52)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('books')
                          .where('year', isEqualTo: '${bookData['year']}')
                          .where('sem', isEqualTo: '${bookData['sem']}')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                  var data = documents[index].data()
                                      as Map<String, dynamic>;
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
                      height: 10.0,
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 28, 210, 34),
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
