import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBMethods {
  final _db = FirebaseFirestore.instance;

  void addUserToDB(User user) async {
    try {
      await _db.collection('users').doc(user.uid).set({
        "uid": user.uid,
        "username": user.displayName,
        "photoURL": user.photoURL,
        "email": user.email,
      });

      print('added user to db');
    } catch (e) {
      print(e);
    }
  }
}
