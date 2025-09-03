import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskService {
  static final Box<Task> _taskBox = Hive.box<Task>('tasks');

  static List<Task> getTasks() {
    return _taskBox.values.toList();
  }

  static Future<void> addTask(Task task) async {
    await _taskBox.add(task);
  }

  static Future<void> updateTask(Task task) async {
    await task.save();
  }

  static Future<void> deleteTask(Task task) async {
    await task.delete();
  }
}
