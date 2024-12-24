class ToDoTask {
  String title;
  String desc;
  bool isComplete;

  ToDoTask({
    required this.title,
    required this.desc,
    this.isComplete = false,
  });

  void toggleComplete() {
    isComplete = !isComplete;
  }
}
