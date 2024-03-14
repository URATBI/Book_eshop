import 'package:flutter/material.dart';
import 'package:studentscopy/get_data/getdata.dart';

class Addtocard extends StatefulWidget {
  const Addtocard({super.key});

  @override
  State<Addtocard> createState() => _AddtocardState();
}

class _AddtocardState extends State<Addtocard> {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fav Books"),
        ),
        body: Text("${userData!['fav_book'].join(', ')}"),
      ),
    );
  }
}
