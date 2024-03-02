import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  Future<Map<String, dynamic>?> getDataForUser() async {
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(_user!.uid)
            .get();

        if (userSnapshot.exists) {
          var userData = userSnapshot.data();
          print('User data: $userData');
          return userData as Map<String, dynamic>;
        } else {
          print('No such document!');
          return null;
        }
      } else {
        print('User is not signed in!');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
