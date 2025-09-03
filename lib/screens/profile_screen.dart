import 'package:flutter/material.dart';
import 'dart:math';

class ProfileScreen extends StatefulWidget {
  final ValueNotifier<bool>? themeNotifier;
  ProfileScreen({this.themeNotifier});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool get isDarkMode => widget.themeNotifier?.value ?? false;
  final List<String> quotes = [
    'Success is the sum of small efforts, repeated day in and day out.',
    'Productivity is never an accident. It is always the result of a commitment to excellence.',
    'The secret of getting ahead is getting started.',
    'Don’t watch the clock; do what it does. Keep going.',
    'Great things are done by a series of small things brought together.',
    'Motivation gets you going, but discipline keeps you growing.'
  ];
  String? _quote;

  @override
  void initState() {
    super.initState();
    _quote = quotes[Random().nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile & Settings')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.pink[100],
                child: Icon(Icons.person, size: 48, color: Colors.pink[300]),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text('FocusFlow', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink[300])),
            ),
            SizedBox(height: 8),
            Center(
              child: Text('A modern productivity app', style: TextStyle(color: Colors.black54)),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dark Mode', style: TextStyle(fontSize: 18)),
                Switch(
                  value: isDarkMode,
                  activeColor: Colors.teal[300],
                  onChanged: (val) {
                    widget.themeNotifier?.value = val;
                  },
                )
              ],
            ),
            Divider(height: 32),
            Text('Motivational Quote', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[300])),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Text(_quote ?? '', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black87)),
            ),
            SizedBox(height: 24),
            Text('Backup & Export', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[300])),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[200]),
                  icon: Icon(Icons.backup),
                  label: Text('Backup Data'),
                  onPressed: () {
                    // TODO: Implement backup/export functionality
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup not implemented in POC.')));
                  },
                ),
                SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: Icon(Icons.restore, color: Colors.teal[300]),
                  label: Text('Restore'),
                  onPressed: () {
                    // TODO: Implement restore functionality
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Restore not implemented in POC.')));
                  },
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
