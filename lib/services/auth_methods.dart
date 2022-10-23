import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studie/services/db_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<String> signInWithGoogle() async {
    String result = "success";
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return result = "Đăng nhập không thành công!";

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCred.user == null) return result = "Đăng nhập không thành công!";
      if (userCred.additionalUserInfo!.isNewUser) {
        DBMethods().addUserToDB(userCred.user!);
      }
    } catch (e) {
      result = "Đăng nhập không thành công: $e";
    }

    return result;
  }

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    String result = "success";
    if (email.isEmpty || password.isEmpty) {
      return result = "Email và mật khẩu không được bỏ trống!";
    }

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      DBMethods().addUserToDB(cred.user!);
    } catch (e) {
      result = "Đăng nhập không thành công!";
    }

    return result;
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String result = "success";
    if (email.isEmpty || password.isEmpty) {
      return result = "Email và mật khẩu không được bỏ trống!";
    }

    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCred.user != null && userCred.additionalUserInfo!.isNewUser) {
        DBMethods().addUserToDB(userCred.user!);
      }
    } catch (e) {
      result = "Đăng nhập không thành công!";
    }

    return result;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      debugPrint('signed out successfully');
    } catch (e) {
      debugPrint('error signing out: $e');
    }
  }
}
