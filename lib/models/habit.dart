import 'package:hive/hive.dart';
part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? notes;

  @HiveField(2)
  List<DateTime> completions;

  @HiveField(3)
  int frequency; // 0: daily, 1: weekly, 2: custom (future)

  Habit({
    required this.name,
    this.notes,
    this.completions = const [],
    this.frequency = 0,
  });
}
