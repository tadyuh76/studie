import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:studie/services/db_methods.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser!;

  Future signUp({required String email, required String password}) async {
    try {
      if (email.isEmpty || password.isEmpty) return;

      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      DBMethods().addUserToDB(userCred.user!);

      debugPrint('sign up successfully, uid: ${userCred.user?.uid}');
    } catch (e) {
      debugPrint("error signing up: $e");
    }
  }

  Future signInWithEmailAndPassworrd({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) return;

      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('sign in successfully, uid: ${userCred.user?.uid}');
    } catch (e) {
      debugPrint('error signing in: $e');
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      debugPrint('signed out successfully');
    } catch (e) {
      debugPrint('error signing out: $e');
    }
  }
}
