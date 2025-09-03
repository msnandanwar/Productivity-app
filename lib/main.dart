import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';
import 'models/habit.dart';
import 'models/note.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(TaskAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HabitAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<Note>('notes');
  await Hive.openBox('settings');

  runApp(FocusFlowRoot());
}

class FocusFlowRoot extends StatefulWidget {
  @override
  State<FocusFlowRoot> createState() => _FocusFlowRootState();
}

class _FocusFlowRootState extends State<FocusFlowRoot> {
  late ValueNotifier<bool> isDarkMode;

  @override
  void initState() {
    super.initState();
    final settings = Hive.box('settings');
    isDarkMode = ValueNotifier<bool>(settings.get('darkMode', defaultValue: false));
    isDarkMode.addListener(() {
      settings.put('darkMode', isDarkMode.value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, dark, _) {
        return MaterialApp(
          title: 'FocusFlow',
          theme: ThemeData(
            brightness: dark ? Brightness.dark : Brightness.light,
            primarySwatch: Colors.pink,
            scaffoldBackgroundColor: dark ? Color(0xFF23222B) : Color(0xFFFFF1F8),
            appBarTheme: AppBarTheme(
              backgroundColor: dark ? Color(0xFF29283A) : Colors.white,
              foregroundColor: Colors.pink[300],
              elevation: 0,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.pink[200],
            ),
            cardTheme: CardTheme(
              color: dark ? Color(0xFF2C2B3B) : Colors.pink[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: dark ? Color(0xFF23222B) : Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Color(0xFF212121),
            scaffoldBackgroundColor: Color(0xFF23272A),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF23272A),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          home: HomeScreen(themeNotifier: isDarkMode),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
