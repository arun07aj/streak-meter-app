import 'package:streak_meter/models/frequency.dart';

class Task {
  final String name;
  final Frequency frequency;
  int currentStreak;
  int maxStreak;
  bool isActive;

  Task({required this.name, required this.frequency, this.currentStreak = 0, this.maxStreak = 0, this.isActive=true});
}