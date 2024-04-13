import 'package:flutter/material.dart';

void main() => runApp(const StreakMeterApp());

class StreakMeterApp extends StatelessWidget {
  const StreakMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}




