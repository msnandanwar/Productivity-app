import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import 'package:intl/intl.dart';

class HabitsScreen extends StatefulWidget {
  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Habits')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Habit>('habits').listenable(),
        builder: (context, Box<Habit> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No habits yet! Tap + to add.',
                  style: TextStyle(fontSize: 18, color: Colors.pink[200])),
            );
          }
          final habits = box.values.toList();
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: habits.length,
            separatorBuilder: (_, __) => SizedBox(height: 8),
            itemBuilder: (context, i) {
              final habit = habits[i];
              final today = DateTime.now();
              final doneToday = habit.completions.any((d) => _isSameDay(d, today));
              final streak = _calculateStreak(habit);
              return Dismissible(
                key: ValueKey(habit.key),
                background: Container(color: Colors.red[100], alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 24), child: Icon(Icons.delete, color: Colors.red)),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) async {
                  await HabitService.deleteHabit(habit);
                },
                child: Card(
                  color: doneToday ? Colors.teal[50] : Colors.pink[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(doneToday ? Icons.check_circle : Icons.radio_button_unchecked, color: doneToday ? Colors.teal : Colors.pink[200]),
                      onPressed: doneToday
                          ? null
                          : () async {
                              await HabitService.markHabitDone(habit, today);
                              setState(() {});
                            },
                    ),
                    title: Text(
                      habit.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (habit.notes != null && habit.notes!.trim().isNotEmpty)
                          Text(habit.notes!, style: TextStyle(color: Colors.black54)),
                        SizedBox(height: 2),
                        Text('Streak: $streak', style: TextStyle(color: Colors.teal)),
                        if (habit.completions.isNotEmpty)
                          Text('Last done: ' + DateFormat('MMM d, yyyy').format(habit.completions.last), style: TextStyle(color: Colors.pink[300])),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey[400]),
                      onPressed: () => _showEditHabitDialog(context, habit),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add Habit',
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _notesController = TextEditingController();
    int _frequency = 0;
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
                Text('Add Habit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink[400])),
                SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Habit Name',
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
                DropdownButton<int>(
                  value: _frequency,
                  items: [
                    DropdownMenuItem(child: Text('Daily'), value: 0),
                    DropdownMenuItem(child: Text('Weekly'), value: 1),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _frequency = val ?? 0;
                    });
                  },
                  dropdownColor: Colors.pink[50],
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
                    child: Text('Add Habit'),
                    onPressed: () async {
                      if (_nameController.text.trim().isEmpty) return;
                      final newHabit = Habit(
                        name: _nameController.text.trim(),
                        notes: _notesController.text.trim(),
                        frequency: _frequency,
                        completions: [],
                      );
                      await HabitService.addHabit(newHabit);
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

  void _showEditHabitDialog(BuildContext context, Habit habit) {
    final _nameController = TextEditingController(text: habit.name);
    final _notesController = TextEditingController(text: habit.notes ?? '');
    int _frequency = habit.frequency;
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
                Text('Edit Habit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink[400])),
                SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Habit Name',
                    border: OutlineInputBorder(),
                  ),
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
                DropdownButton<int>(
                  value: _frequency,
                  items: [
                    DropdownMenuItem(child: Text('Daily'), value: 0),
                    DropdownMenuItem(child: Text('Weekly'), value: 1),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _frequency = val ?? 0;
                    });
                  },
                  dropdownColor: Colors.pink[50],
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
                    child: Text('Save Changes'),
                    onPressed: () async {
                      habit.name = _nameController.text.trim();
                      habit.notes = _notesController.text.trim();
                      habit.frequency = _frequency;
                      await HabitService.updateHabit(habit);
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

  int _calculateStreak(Habit habit) {
    final completions = List<DateTime>.from(habit.completions)..sort((a, b) => b.compareTo(a));
    if (completions.isEmpty) return 0;
    int streak = 0;
    DateTime current = DateTime.now();
    for (final d in completions) {
      if (_isSameDay(d, current)) {
        streak++;
        current = current.subtract(Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
