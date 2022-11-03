import 'package:studie/models/note.dart';

class Message {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String senderPhotoURL;
  final String createdAt;
  String type;
  Note? note;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoURL,
    required this.text,
    required this.createdAt,
    this.type = "message",
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "senderId": senderId,
      "senderName": senderName,
      "senderPhotoURL": senderPhotoURL,
      "createdAt": createdAt,
      "type": type,
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
      type: json["type"] ?? "message",
    );
  }

  void addNote(Note newNote) {
    note = newNote;
  }
}
