# API Documentation

## Overview
FocusFlow is a productivity app with task management, habit tracking, timer functionality, and note-taking capabilities. This document outlines the internal API structure and data models.

## Data Models

### Task Model
```dart
@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0) String title;         // Task title (required)
  @HiveField(1) String? notes;        // Optional notes/description
  @HiveField(2) DateTime? dueDate;    // Optional due date
  @HiveField(3) bool completed;       // Completion status
  @HiveField(4) int priority;         // Priority level (0-3)
}
```

**Priority Levels:**
- `0` - No priority
- `1` - Low priority (teal indicator)
- `2` - Medium priority (orange indicator)  
- `3` - High priority (red indicator)

### Habit Model
```dart
@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0) String name;              // Habit name (required)
  @HiveField(1) String? notes;            // Optional description
  @HiveField(2) List<DateTime> completions; // Completion timestamps
  @HiveField(3) int frequency;            // Frequency type
}
```

**Frequency Types:**
- `0` - Daily habit
- `1` - Weekly habit

### Note Model
```dart
@HiveType(typeId: 2)
class Note extends HiveObject {
  @HiveField(0) String title;         // Note title
  @HiveField(1) String content;       // Note content
  @HiveField(2) DateTime createdAt;   // Creation timestamp
}
```

## Service Layer

### TaskService
Manages all task-related operations with Hive persistence.

```dart
class TaskService {
  static List<Task> getTasks()              // Retrieve all tasks
  static Future<void> addTask(Task task)    // Add new task
  static Future<void> updateTask(Task task) // Update existing task
  static Future<void> deleteTask(Task task) // Delete task
}
```

### HabitService  
Handles habit tracking and completion management.

```dart
class HabitService {
  static List<Habit> getHabits()                          // Get all habits
  static Future<void> addHabit(Habit habit)               // Add new habit
  static Future<void> updateHabit(Habit habit)            // Update habit
  static Future<void> deleteHabit(Habit habit)            // Delete habit
  static Future<void> markHabitDone(Habit, DateTime)      // Mark completion
}
```

### NoteService
Manages note creation, updates, and deletion.

```dart
class NoteService {
  static List<Note> getNotes()              // Retrieve all notes
  static Future<void> addNote(Note note)    // Add new note  
  static Future<void> updateNote(Note note) // Update note
  static Future<void> deleteNote(Note note) // Delete note
}
```

## Business Logic

### Streak Calculation Algorithm
```dart
int _calculateStreak(Habit habit) {
  final completions = List<DateTime>.from(habit.completions)
    ..sort((a, b) => b.compareTo(a));
  
  if (completions.isEmpty) return 0;
  
  int streak = 0;
  DateTime current = DateTime.now();
  
  for (final completion in completions) {
    if (_isSameDay(completion, current)) {
      streak++;
      current = current.subtract(Duration(days: 1));
    } else {
      break; // Streak broken
    }
  }
  
  return streak;
}
```

### Timer Implementation
The Pomodoro timer uses `Timer.periodic` for background execution:

```dart
class TimerScreen extends StatefulWidget {
  // Default settings
  int workMinutes = 25;     // Work session duration
  int breakMinutes = 5;     // Break session duration
  bool isWorkSession = true; // Current session type
  List<String> sessionHistory = []; // Completed sessions (max 10)
  
  void startTimer()  // Begin countdown
  void stopTimer()   // Pause/stop timer
  void resetTimer()  // Reset to session start
}
```

## Data Flow Architecture

### Screen → Service → Model Pattern
1. **Screens** handle user interactions and UI state
2. **Services** manage business logic and data validation
3. **Models** define data structures and Hive persistence
4. **Hive Database** provides offline-first storage

### Reactive UI Updates
Uses `ValueListenableBuilder` for automatic UI updates when Hive data changes:

```dart
ValueListenableBuilder(
  valueListenable: Hive.box<Task>('tasks').listenable(),
  builder: (context, Box<Task> box, _) {
    final tasks = box.values.toList();
    return ListView(/* render tasks */);
  },
)
```

## Database Schema

### Hive Boxes
- `'tasks'` - Box<Task> - Task storage
- `'habits'` - Box<Habit> - Habit storage  
- `'notes'` - Box<Note> - Note storage
- `'settings'` - Box<dynamic> - App preferences

### Type Adapters
Generated adapters handle object serialization:
- `TaskAdapter` (typeId: 0)
- `HabitAdapter` (typeId: 1)  
- `NoteAdapter` (typeId: 2)

## Navigation Structure

### Bottom Navigation Tabs
```dart
final List<BottomNavigationBarItem> _navItems = [
  BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Tasks'),
  BottomNavigationBarItem(icon: Icon(Icons.repeat), label: 'Habits'),
  BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
  BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Planner'),
  BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
];
```

### Screen Routing
- Index 0: TasksScreen - Task management
- Index 1: HabitsScreen - Habit tracking
- Index 2: TimerScreen - Pomodoro timer
- Index 3: PlannerScreen - Calendar view
- Index 4: NotesScreen - Note management
- Index 5: ProfileScreen - Settings & theme

## Error Handling

### Common Patterns
```dart
try {
  await service.performOperation();
  // Success feedback
} catch (e) {
  // Show user-friendly error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Operation failed: ${e.toString()}')),
  );
}
```

### Validation
- Task titles are required (non-empty)
- Habit names are required (non-empty)
- Note titles default to "(Untitled)" if empty
- Dates handle timezone considerations

## Theme System

### Color Scheme
```dart
// Primary colors (pink palette)
Colors.pink[50]   // Light backgrounds
Colors.pink[100]  // Card accents
Colors.pink[200]  // Primary buttons
Colors.pink[300]  // Text highlights

// Secondary colors (teal palette)
Colors.teal       // Success states
Colors.teal[50]   // Completed item backgrounds
Colors.teal[300]  // Secondary highlights
```

### Dark Mode
Managed through `ValueNotifier<bool>` with Hive persistence:
```dart
final settings = Hive.box('settings');
isDarkMode = ValueNotifier<bool>(settings.get('darkMode', defaultValue: false));
```

## Performance Considerations

### List Rendering
- Uses `ListView.separated` for optimal scrolling
- Implements efficient item builders
- Proper key assignment for animations

### Memory Management  
- Controllers disposed in `dispose()` methods
- Timers cancelled appropriately
- Minimal widget rebuilds with targeted listeners

### Offline Performance
- All data operations are local (Hive)
- No network dependencies
- Fast startup with local database
