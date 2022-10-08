import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  final String uid;
  final String username;
  final String email;
  final String photoURL;

  User({
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

  factory User.fromFirebaseUser(auth.User user) {
    return User(
      uid: user.uid,
      username: user.displayName ?? '',
      email: user.email ?? '',
      photoURL: user.photoURL ?? '',
    );
  }
}
