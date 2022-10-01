class User {
  final String uid;
  final String username;
  final String email;
  final String profileURL;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.profileURL,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "profileImg": profileURL,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      profileURL: json['profileURL'],
    );
  }
}
