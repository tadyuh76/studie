import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String photoURL;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoURL,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "profileImg": photoURL,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      username: json["username"],
      email: json["email"],
      photoURL: json["photoURL"],
    );
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      username: user.displayName ?? '',
      email: user.email ?? '',
      photoURL: user.photoURL ?? '',
    );
  }
}
