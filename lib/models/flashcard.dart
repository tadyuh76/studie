class Flashcard {
  String _id = "";
  final String front;
  final String back;
  final int revisedTimes;

  String get id => _id;

  Flashcard({
    required this.front,
    required this.back,
    required this.revisedTimes,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "front": front,
      "back": back,
      "revisedTimes": revisedTimes,
    };
  }

  Flashcard copyWith(String id) {
    _id = id;
    return Flashcard(front: front, back: back, revisedTimes: revisedTimes);
  }
}
