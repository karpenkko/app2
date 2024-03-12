import 'package:flutter/material.dart';
import 'package:app2/models/task_manager.dart';
import 'package:app2/models/user.dart';
import 'package:app2/models/wishes.dart';


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
  void dispose() {
    _textEditingController.dispose();
    _dateEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    taskCounter = () => taskCount++;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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











