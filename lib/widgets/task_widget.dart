import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Task: ${task.name}',
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Streak: ${task.currentStreak}, Max Streak: ${task.maxStreak}',
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 1000.0, // Width of the scale
            height: 20.0, // Height of the scale
            decoration: BoxDecoration(
              color: _getColorBasedOnStreak(task.currentStreak, task.maxStreak),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorBasedOnStreak(int streak, int maxStreak) {
    double percentage = (maxStreak == 0) ? 25 : (streak / maxStreak) * 100;

    if (streak == 0) return Colors.red;
    if (percentage <= 15) return Colors.yellow;
    if (percentage <= 35) return Colors.lightGreenAccent;
    if (percentage <= 60) return Colors.green;
    if (percentage <= 100) return Colors.green[700]!;
    return Colors.green[900]!;
  }
}