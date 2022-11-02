class Note {
  String id;
  String title;
  String text;
  String lastEdit;
  String color;
  String folderName;

  Note({
    this.id = "",
    required this.title,
    required this.text,
    required this.lastEdit,
    required this.color,
    required this.folderName,
  });

  Note copyWith({
    String? newId,
    String? newTitle,
    String? newText,
    String? newFolderName,
    String? newColor,
  }) {
    id = newId ?? id;
    title = newTitle ?? title;
    text = newText ?? text;
    folderName = newFolderName ?? folderName;
    color = newColor ?? color;

    lastEdit = DateTime.now().toString();

    return this;
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["id"],
      title: json["title"],
      text: json["text"],
      lastEdit: json["lastEdit"],
      color: json["color"],
      folderName: json["folderName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "text": text,
      "lastEdit": lastEdit,
      "color": color,
      "folderName": folderName,
    };
  }

  factory Note.empty() {
    return Note(
      title: "(Không có tiêu đề)",
      text: "",
      lastEdit: DateTime.now().toString(),
      color: "blue",
      folderName: "all",
    );
  }
}
