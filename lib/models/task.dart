import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String? notes;

  @HiveField(2)
  DateTime? dueDate;

  @HiveField(3)
  bool completed;

  @HiveField(4)
  int priority; // 0 = none, 1 = low, 2 = med, 3 = high

  Task({
    required this.title,
    this.notes,
    this.dueDate,
    this.completed = false,
    this.priority = 0,
  });
}
