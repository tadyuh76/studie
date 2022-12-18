class AgoraUser {
  final int localUid;
  final String name;
  final String photoUrl;
  bool cameraEnable;
  bool micEnable;

  AgoraUser({
    required this.name,
    required this.localUid,
    required this.photoUrl,
    required this.cameraEnable,
    required this.micEnable,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "localUid": localUid,
      "photoUrl": photoUrl,
      "cameraEnable": cameraEnable,
      "micEnable": micEnable,
    };
  }

  factory AgoraUser.fromJson(Map<String, dynamic> json) {
    return AgoraUser(
      name: json['name'],
      localUid: json['localUid'],
      photoUrl: json['photoUrl'],
      cameraEnable: json['cameraEnable'],
      micEnable: json['micEnable'],
    );
  }
}
