class Note {
  String id;
  String title;
  String text;
  String lastEdit;
  String color;
  String folderName;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.lastEdit,
    required this.color,
    required this.folderName,
  });

  void copyWith({
    String? newTitle,
    String? newText,
    String? newFolderName,
    String? newColor,
  }) {
    title = newTitle ?? title;
    text = newText ?? text;
    folderName = newFolderName ?? folderName;
    color = newColor ?? color;
  }
}
