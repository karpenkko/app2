import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TaskListPage(),
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});
  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> with WishesList{
  final TaskManager taskManager = TaskManager();
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _dateEditingController = TextEditingController();
  final User user = User.guest('Yaroslava');
  late final Wishes wish = Wishes();
  var taskCount = 0;
  late Function taskCounter;

  @override
  Widget build(BuildContext context) {
    taskCounter = () => taskCount++;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task List – ${user.getUsername()}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 103, 80, 163),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: taskManager.tasks.length,
        itemBuilder: (context, index) {
          final task = taskManager.tasks[index];
          return ListTile(
            title: Text('${task.title} - ${task.date}'),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                setState(() => taskManager.changeLabel(index));
              },
            ),
            onLongPress: () {
              setState(() => taskManager.deleteTask(index));
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              'All created tasks: $taskCount',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          FloatingActionButton(
            onPressed: () => addTaskForm(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            wish.getWish(),
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  void addTaskForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(labelText: 'Task title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dateEditingController,
                decoration: const InputDecoration(labelText: 'Task date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                taskCounter();
                final title = _textEditingController.text;
                final date = _dateEditingController.text;
                if (date.isEmpty) {
                  setState(() => taskManager.addTask(title));
                } else {
                  setState(() => taskManager.addTask(title, date: date));
                }
                _textEditingController.clear();
                _dateEditingController.clear();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Task{
  String title;
  bool isCompleted;
  String date;

  Task(this.title, this.date, {this.isCompleted = false});

  void changeCompleted() {
    isCompleted = !isCompleted;
  }
}

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

mixin UserCache {
  static Map<String, User> userCache = {};
}

class User with UserCache {
  String username;
  int age;

  User({required this.username, required this.age});

  factory User.guest(String name) => UserCache.userCache.containsKey(name) ? UserCache.userCache[name]! : User(username: 'Guest', age: 0);

  String getUsername() => username;
}


mixin WishesList{
  late final Map<String, String> wishes = {
    'Monday': 'Have a great start of the week!',
    'Tuesday': 'Stay motivated and focused!',
    'Wednesday': 'Halfway through, you can do it!',
    'Thursday': 'Keep pushing, the weekend is near!',
    'Friday': 'Weekend is almost here, hang in there!',
    'Saturday': 'Enjoy your weekend to the fullest!',
    'Sunday': 'Relax and recharge for the week ahead!'
  };
}

class Wishes with WishesList {
  final now = DateTime.now();

  String getWish() {
    final currentDay = now.weekday;
    final dayName = getDayName(currentDay);
    return wishes[dayName] ?? '';
  }

  String getDayName(int currentDay) {
    final Set<String> dayNames = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'};
    return (currentDay >= 1 && currentDay <= 7) ? dayNames.elementAt(currentDay - 1) : '';
  }
}


