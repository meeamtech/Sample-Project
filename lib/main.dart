import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<dynamic> _todos = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // 🔥 Load tasks from backend
  void loadTasks() async {
    final data = await ApiService.getTasks();
    if (mounted) {
      setState(() {
        _todos = data;
      });
    }
  }

  // ➕ Add task
  void _addTodo(String title) async {
    if (title.trim().isEmpty) return;

    await ApiService.addTask(title.trim());
    loadTasks();
    _textController.clear();
  }

  // ✅ Toggle complete
  void _toggleTodo(int index) async {
    final todo = _todos[index];

    await ApiService.updateTask(
      todo['id'],
      todo['title'],
      !todo['is_completed'],
    );

    loadTasks();
  }

  // ❌ Delete task
  void _deleteTodo(int index) async {
    final id = _todos[index]['id'];

    await ApiService.deleteTask(id);
    loadTasks();
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Task'),
          content: TextField(
            controller: _textController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task...',
            ),
            onSubmitted: (value) {
              _addTodo(value);
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _textController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                _addTodo(_textController.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sabeeh'),
      ),
      body: _todos.isEmpty
          ? const Center(child: Text("No tasks yet"))
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];

                return ListTile(
                  leading: Checkbox(
                    value: todo['is_completed'] ?? false,
                    onChanged: (value) {
                      _toggleTodo(index);
                    },
                  ),
                  title: Text(
                    todo['title'] ?? '',
                    style: TextStyle(
                      decoration: todo['is_completed'] == true
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTodo(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}