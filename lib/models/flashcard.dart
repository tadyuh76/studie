class Flashcard {
  String _id = "";
  final String front;
  final String back;
  final int revisedTimes;
  final String curTitle;
  final String noteName;
  final String folderName;

  String get id => _id;

  Flashcard({
    required this.front,
    required this.back,
    required this.revisedTimes,
    required this.curTitle,
    required this.noteName,
    required this.folderName,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "front": front,
      "back": back,
      "revisedTimes": revisedTimes,
      "curTitle": curTitle,
      "noteName": noteName,
      "folderName": folderName,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    final card = Flashcard(
      front: json["front"],
      back: json["back"],
      revisedTimes: json["revisedTimes"],
      curTitle: json["curTitle"],
      noteName: json["noteName"],
      folderName: json["folderName"],
    );
    card._id = json["id"];
    return card;
  }

  Flashcard copyWith(String id) {
    _id = id;
    return this;
  }
}
