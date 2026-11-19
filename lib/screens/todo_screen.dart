import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TaskModel> _tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => isLoading = true);
    final tasks = await DatabaseHelper().getAllTasks();
    setState(() {
      _tasks = tasks;
      isLoading = false;
    });
  }

  Future<void> _addTask(String title) async {
    final newTask = TaskModel(
      title: title,
      date: DateTime.now().toString().split(' ')[0],
      priority: 'Medium',
      isCompleted: 0,
    );
    await DatabaseHelper().insertTask(newTask);
    _loadTasks();
  }

  Future<void> _toggleTask(TaskModel task, bool? value) async {
    int newStatus = value == true ? 1 : 0;
    await DatabaseHelper().updateTaskStatus(task.id!, newStatus);
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    _loadTasks();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully')),
      );
    }
  }

  void _showAddTaskDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter task details'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addTask(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: const Color(0xFF1877F2),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks yet. Add one!',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Dismissible(
                      key: Key(task.id.toString()),
                      direction: DismissDirection.endToStart, // Swipe left to delete
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: const Color(0xFFFA383E), // Red color for delete
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteTask(task.id!);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isCompleted == 1,
                            activeColor: const Color(0xFF42B72A),
                            onChanged: (val) => _toggleTask(task, val),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted == 1 ? TextDecoration.lineThrough : null,
                              color: task.isCompleted == 1 ? Colors.grey : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey),
                            onPressed: () => _deleteTask(task.id!),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1877F2),
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
