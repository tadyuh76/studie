import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:studie/services/db_methods.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser!;

  Future<void> signUp({required String email, required String password}) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await DBMethods().addUserToDB(userCred.user!);

      debugPrint('sign up successfully, uid: ${userCred.user?.uid}');
    } catch (e) {
      debugPrint("error signing up: $e");
    }
  }

  Future<void> signInWithEmailAndPassworrd({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('error signing in: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint('signed out successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint('error signing out: $e');
    }
  }
}
