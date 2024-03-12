import 'package:app2/models/task.dart';

class TaskManager {
  List<Task> tasks = [];

  void addTask(String title, {String date = '29.02'}) {
    assert(title.isNotEmpty, 'Title shouldn\'t be empty');
    Task task = Task(title, date);
    tasks.add(task);
  }

  void changeLabel(int index) {
    tasks[index].changeCompleted();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
  }
}