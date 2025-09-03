import 'package:flutter/material.dart';
import 'tasks_screen.dart';
import 'habits_screen.dart';
import 'timer_screen.dart';
import 'planner_screen.dart';
import 'notes_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueNotifier<bool>? themeNotifier;
  HomeScreen({this.themeNotifier});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;



  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Tasks'),
    BottomNavigationBarItem(icon: Icon(Icons.repeat), label: 'Habits'),
    BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Planner'),
    BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      TasksScreen(),
      HabitsScreen(),
      TimerScreen(),
      PlannerScreen(),
      NotesScreen(),
      ProfileScreen(themeNotifier: widget.themeNotifier),
    ];
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
