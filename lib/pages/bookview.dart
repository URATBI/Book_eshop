import 'package:flutter/material.dart';

class Bookview extends StatefulWidget {
  final String bookid;

  const Bookview({required this.bookid});

  @override
  State<Bookview> createState() => _BookviewState();
}

class _BookviewState extends State<Bookview> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 300.0,
            ),
            Text('${widget.bookid}'),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('back'),
            ),
          ],
        ),
      ),
    );
  }
}
