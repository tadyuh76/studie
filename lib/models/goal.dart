class Goal {
  final String text;
  bool completed;

  Goal({required this.text, required this.completed});

  void doneTask() {
    completed = !completed;
  }
}
