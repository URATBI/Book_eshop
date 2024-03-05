import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studentscopy/pages/bookview.dart';

class Depbooks extends StatefulWidget {
  final String year;

  const Depbooks({required this.year});

  @override
  State<Depbooks> createState() => _DepbooksState();
}

class _DepbooksState extends State<Depbooks> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text("IT"),
                ),
                Tab(
                  child: Text("CSE"),
                ),
                Tab(
                  child: Text("ECE"),
                ),
                Tab(
                  child: Text("MECH"),
                ),
                Tab(
                  child: Text("AIDS"),
                )
              ],
            ),
            title: Text('${widget.year}\'st Year'),
          ),
          body: TabBarView(
            children: [
              _buildDepartmentBooks('IT'),
              _buildDepartmentBooks('CSE'),
              _buildDepartmentBooks('ECE'),
              _buildDepartmentBooks('MECH'),
              _buildDepartmentBooks('AIDS'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentBooks(String department) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('books')
          .where('year', isEqualTo: widget.year)
          .where('department', arrayContains: department)
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
          var documents = snapshot.data?.docs;
          if (documents != null && documents.isNotEmpty) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 2,
                  childAspectRatio: 0.7),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;
                String documentId = documents[index].id;
                return _buildBookCard(data, documentId);
              },
            );
          } else {
            return Center(
              child: Text('No books found for $department department'),
            );
          }
        }
      },
    );
  }

  Widget _buildBookCard(Map<String, dynamic> bookData, String documentId) {
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
                bookData['booknickname'].toString() ?? '',
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
