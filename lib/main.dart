import 'package:flutter/foundation.dart';
import 'package:simple_to_do/task.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCeeVEMcq1f5PTSWckKfVIShOJCTPwtFKQ",
            authDomain: "to-do-simple-b548e.firebaseapp.com",
            projectId: "to-do-simple-b548e",
            storageBucket: "to-do-simple-b548e.firebasestorage.app",
            messagingSenderId: "166111396965",
            appId: "1:166111396965:web:47a9cf5978ea7bd957f28c"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoTask> tasks = [
    ToDoTask(title: "Study Math", desc: "Chapters 2,3"),
    ToDoTask(title: "Exercise", desc: "Go for a run"),
    ToDoTask(title: "Study Science", desc: "Chapter 5")
  ];

  // Controllers for the input fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "To Do List",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.desc),
            trailing: Checkbox(
              value: task.isComplete,
              onChanged: (bool? value) {
                setState(() {
                  task.toggleComplete();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _showAddTaskDialog(context),
        tooltip: 'Add Task',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Function to show the dialog and add a new task
  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Task Title"),
              ),
              TextField(
                controller: descController,
                decoration:
                    const InputDecoration(labelText: "Task Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Add the new task to the list
                if (titleController.text.isNotEmpty &&
                    descController.text.isNotEmpty) {
                  setState(() {
                    tasks.add(ToDoTask(
                      title: titleController.text,
                      desc: descController.text,
                    ));
                  });
                  titleController.clear();
                  descController.clear();
                  Navigator.of(context).pop();
                } else {
                  // Show an error if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in both fields")),
                  );
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        );
      },
    );
  }
}
