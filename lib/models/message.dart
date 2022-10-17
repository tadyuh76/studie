class Message {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String senderPhotoURL;
  final String createdAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoURL,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "senderId": senderId,
      "senderName": senderName,
      "senderPhotoURL": senderPhotoURL,
      "createdAt": createdAt,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      senderId: json["senderId"],
      senderName: json["senderName"],
      senderPhotoURL: json["senderPhotoURL"],
      text: json["text"],
      createdAt: json["createdAt"],
    );
  }
}
