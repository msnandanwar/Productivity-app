import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/habit.dart';
import 'package:intl/intl.dart';

class PlannerScreen extends StatefulWidget {
  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks');
    final habitBox = Hive.box<Habit>('habits');
    final tasks = taskBox.values.where((t) => t.dueDate != null && _isSameDay(t.dueDate!, _selectedDay)).toList();
    final habits = habitBox.values.where((h) => h.frequency == 0 || (h.frequency == 1 && _selectedDay.weekday == DateTime.monday)).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Planner')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildCalendar(),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Text('Tasks for ${DateFormat('MMM d, yyyy').format(_selectedDay)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[300])),
                  ...tasks.isEmpty
                      ? [Text('No tasks for this day.', style: TextStyle(color: Colors.grey))]
                      : tasks.map((t) => ListTile(
                            leading: Icon(t.completed ? Icons.check_circle : Icons.radio_button_unchecked, color: t.completed ? Colors.teal : Colors.pink[200]),
                            title: Text(t.title),
                            subtitle: t.notes != null && t.notes!.isNotEmpty ? Text(t.notes!) : null,
                          )),
                  SizedBox(height: 16),
                  Text('Habits', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[300])),
                  ...habits.isEmpty
                      ? [Text('No habits for this day.', style: TextStyle(color: Colors.grey))]
                      : habits.map((h) => ListTile(
                            leading: Icon(Icons.repeat, color: Colors.teal[200]),
                            title: Text(h.name),
                            subtitle: h.notes != null && h.notes!.isNotEmpty ? Text(h.notes!) : null,
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month - 1, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    final days = <DateTime>[];
    for (int i = 0; i <= lastDay.difference(firstDay).inDays; i++) {
      days.add(firstDay.add(Duration(days: i)));
    }
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, i) {
          final day = days[i];
          final isSelected = _isSameDay(day, _selectedDay);
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = day;
              });
            },
            child: Container(
              width: 60,
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.pink[100] : Colors.pink[50],
                borderRadius: BorderRadius.circular(16),
                border: isSelected ? Border.all(color: Colors.pink[400]!, width: 2) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E').format(day), style: TextStyle(color: Colors.pink[300], fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('${day.day}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 2),
                  if (_isSameDay(day, DateTime.now()))
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.teal[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
