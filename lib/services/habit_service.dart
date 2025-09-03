import 'package:hive/hive.dart';
import '../models/habit.dart';

class HabitService {
  static final Box<Habit> _habitBox = Hive.box<Habit>('habits');

  static List<Habit> getHabits() {
    return _habitBox.values.toList();
  }

  static Future<void> addHabit(Habit habit) async {
    await _habitBox.add(habit);
  }

  static Future<void> updateHabit(Habit habit) async {
    await habit.save();
  }

  static Future<void> deleteHabit(Habit habit) async {
    await habit.delete();
  }

  static Future<void> markHabitDone(Habit habit, DateTime date) async {
    if (!habit.completions.any((d) => _isSameDay(d, date))) {
      habit.completions = List.from(habit.completions)..add(date);
      await habit.save();
    }
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
