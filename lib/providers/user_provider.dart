import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/models/user.dart';

class UserNotifier extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<UserModel?> getUser() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    // _user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    return _user;
  }
}

final userProvider = ChangeNotifierProvider((ref) => UserNotifier());
