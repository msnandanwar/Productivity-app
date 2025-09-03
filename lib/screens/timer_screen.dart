import 'package:flutter/material.dart';
import 'dart:async';

class TimerScreen extends StatefulWidget {
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int workMinutes = 25;
  int breakMinutes = 5;
  int secondsLeft = 25 * 60;
  bool isRunning = false;
  bool isWorkSession = true;
  Timer? timer;
  List<String> sessionHistory = [];

  void startTimer() {
    if (timer != null) timer!.cancel();
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (secondsLeft > 0) {
          secondsLeft--;
        } else {
          timer!.cancel();
          isRunning = false;
          sessionHistory.insert(0, isWorkSession ? 'Work' : 'Break');
          if (sessionHistory.length > 10) sessionHistory = sessionHistory.sublist(0, 10);
          isWorkSession = !isWorkSession;
          secondsLeft = (isWorkSession ? workMinutes : breakMinutes) * 60;
        }
      });
    });
  }

  void stopTimer() {
    if (timer != null) timer!.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    if (timer != null) timer!.cancel();
    setState(() {
      secondsLeft = (isWorkSession ? workMinutes : breakMinutes) * 60;
      isRunning = false;
    });
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Focus Timer')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            Text(
              isWorkSession ? 'Work Session' : 'Break',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isWorkSession ? Colors.pink[300] : Colors.teal[400],
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isWorkSession ? Colors.pink[50] : Colors.teal[50],
                border: Border.all(color: Colors.pink[100]!, width: 4),
              ),
              width: 180,
              height: 180,
              alignment: Alignment.center,
              child: Text(
                formatTime(secondsLeft),
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRunning ? Colors.teal[200] : Colors.pink[200],
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isRunning ? stopTimer : startTimer,
                  child: Text(isRunning ? 'Pause' : 'Start'),
                ),
                SizedBox(width: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.pink[300],
                    side: BorderSide(color: Colors.pink[100]!),
                  ),
                  onPressed: resetTimer,
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeAdjust('Work', workMinutes, (val) {
                  setState(() {
                    workMinutes = val;
                    if (isWorkSession) secondsLeft = workMinutes * 60;
                  });
                }),
                SizedBox(width: 24),
                _buildTimeAdjust('Break', breakMinutes, (val) {
                  setState(() {
                    breakMinutes = val;
                    if (!isWorkSession) secondsLeft = breakMinutes * 60;
                  });
                }),
              ],
            ),
            SizedBox(height: 32),
            Text('Session History', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[300])),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: sessionHistory.length,
                itemBuilder: (context, i) {
                  final session = sessionHistory[i];
                  return ListTile(
                    leading: Icon(session == 'Work' ? Icons.work : Icons.free_breakfast, color: session == 'Work' ? Colors.pink[200] : Colors.teal[300]),
                    title: Text(session + ' completed'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAdjust(String label, int value, void Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: label == 'Work' ? Colors.pink[300] : Colors.teal[400], fontWeight: FontWeight.w500)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.pink[200]),
              onPressed: value > 1 ? () => onChanged(value - 1) : null,
            ),
            Text('$value min', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.teal[200]),
              onPressed: value < 60 ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}
