import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No tasks yet! Tap + to add.',
                  style: TextStyle(fontSize: 18, color: Colors.pink[200])),
            );
          }
          final tasks = box.values.toList();
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => SizedBox(height: 8),
            itemBuilder: (context, i) {
              final task = tasks[i];
              return Dismissible(
                key: ValueKey(task.key),
                background: Container(color: Colors.red[100], alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 24), child: Icon(Icons.delete, color: Colors.red)),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) async {
                  await TaskService.deleteTask(task);
                },
                child: Card(
                  color: task.completed ? Colors.teal[50] : Colors.pink[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.completed,
                      activeColor: Colors.teal,
                      onChanged: (val) async {
                        task.completed = val ?? false;
                        await TaskService.updateTask(task);
                        setState(() {});
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        decoration: task.completed ? TextDecoration.lineThrough : null,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.notes != null && task.notes!.trim().isNotEmpty)
                          Text(task.notes!, style: TextStyle(color: Colors.black54)),
                        if (task.dueDate != null)
                          Text('Due: ' + DateFormat('MMM d, yyyy').format(task.dueDate!), style: TextStyle(color: Colors.pink[300])),
                        if (task.priority > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Row(
                              children: [
                                Icon(Icons.flag, color: _priorityColor(task.priority), size: 16),
                                SizedBox(width: 4),
                                Text(_priorityLabel(task.priority), style: TextStyle(color: _priorityColor(task.priority), fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                      ],
                    ),
                    trailing: Icon(Icons.drag_handle, color: Colors.grey[400]),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _notesController = TextEditingController();
    DateTime? _dueDate;
    int _priority = 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink[400])),
                SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.calendar_today, color: Colors.pink[300]),
                        label: Text(_dueDate == null ? 'Set Due Date' : DateFormat('MMM d, yyyy').format(_dueDate!)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.pink[300],
                          side: BorderSide(color: Colors.pink[100]!),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 365 * 5)),
                          );
                          if (picked != null) {
                            setState(() {
                              _dueDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    DropdownButton<int>(
                      value: _priority,
                      items: [
                        DropdownMenuItem(child: Text('No Priority'), value: 0),
                        DropdownMenuItem(child: Text('Low'), value: 1),
                        DropdownMenuItem(child: Text('Medium'), value: 2),
                        DropdownMenuItem(child: Text('High'), value: 3),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _priority = val ?? 0;
                        });
                      },
                      dropdownColor: Colors.pink[50],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[200],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Add Task'),
                    onPressed: () async {
                      if (_titleController.text.trim().isEmpty) return;
                      final newTask = Task(
                        title: _titleController.text.trim(),
                        notes: _notesController.text.trim(),
                        dueDate: _dueDate,
                        priority: _priority,
                        completed: false,
                      );
                      await TaskService.addTask(newTask);
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _priorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.teal;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  String _priorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return '';
    }
  }
}
