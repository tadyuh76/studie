import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/models/user.dart';

class UserNotifier extends ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user!;

  Future<void> updateUser() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();
      if (!snapshot.exists) return;
      debugPrint("got user data from firestore: ${snapshot.data()}");
      _user = UserModel.fromJson(snapshot.data()!);
      notifyListeners();
    } catch (e) {
      debugPrint('error getting user model from provider: $e');
    }
  }
}

final userProvider = ChangeNotifierProvider((ref) => UserNotifier());
