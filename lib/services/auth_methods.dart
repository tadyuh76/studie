import 'package:firebase_auth/firebase_auth.dart';
import 'package:studie/models/user.dart' as model;
import 'package:studie/services/db_methods.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;

  Future signUp({required String email, required String password}) async {
    try {
      if (email.isEmpty || password.isEmpty) return;

      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      DBMethods().addUserToDB(userCred.user!);

      print('sign up successfully, uid: ${userCred.user?.uid}');
    } catch (e) {
      print(e);
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
      print('sign in successfully, uid: ${userCred.user?.uid}');
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      print('signed out successfully');
    } catch (e) {
      print(e);
    }
  }
}
