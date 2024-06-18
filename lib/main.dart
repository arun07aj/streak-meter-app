import 'package:flutter/material.dart';
import 'package:streak_meter/widgets/about_page.dart';
import 'package:streak_meter/widgets/home_page.dart';

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
      home: const HomePage(),
      routes: {
        '/about': (context) => const AboutPage(),
      },
    );
  }
}




