import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentscopy/pages/bookview.dart';

class Searchbooks extends StatefulWidget {
  const Searchbooks({Key? key}) : super(key: key);

  @override
  State<Searchbooks> createState() => _SearchbooksState();
}

class _SearchbooksState extends State<Searchbooks> {
  List bookresult = [];
  List booksearchresult = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onsearchchange);
  }

  _onsearchchange() {
    print(_controller.text);
    searchResultlist(); // Call searchResultlist method when text changes
  }

  Future<void> getClientBooks() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('books')
          .orderBy('bookname')
          .get();
      setState(() {
        bookresult = snapshot.docs;
      });
    } catch (e) {
      print("Error fetching books: $e");
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onsearchchange);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getClientBooks();
  }

  searchResultlist() {
    var Resultdata = [];
    if (_controller.text != '') {
      for (var char in bookresult) {
        var name = char['bookname'].toString().toLowerCase();
        if (name.contains(_controller.text.toLowerCase())) {
          Resultdata.add(char);
        }
      }
    } else {
      Resultdata = List.from(bookresult);
    }
    setState(() {
      booksearchresult = Resultdata;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: CupertinoSearchTextField(
            controller: _controller,
          ),
        ),
        body: ListView.builder(
          itemCount: booksearchresult.length,
          itemBuilder: (context, index) {
            var bookData = booksearchresult[index].data();
            return GestureDetector(
              onTap: () {
                String documentId = booksearchresult[index].id;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Bookview(bookid: documentId)),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Image.network(
                    bookData['bookpic'],
                    width: 40,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(bookData['booknickname']),
                  subtitle: Text(bookData['bookname']),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
