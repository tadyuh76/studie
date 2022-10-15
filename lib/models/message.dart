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
}
