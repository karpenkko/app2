class Task{
  String title;
  bool isCompleted;
  String date;

  Task(this.title, this.date, {this.isCompleted = false});

  void changeCompleted() {
    isCompleted = !isCompleted;
  }
}