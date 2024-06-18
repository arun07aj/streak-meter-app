import 'package:uuid/uuid.dart';
import 'package:streak_meter/models/frequency.dart';
import '../utils/constants.dart';

class Task {
  final String id;
  final String name;
  final Frequency frequency;
  DateTime startDateTime;
  int currentStreak;
  int maxStreak;
  bool isActive;

  Task(
      {required this.name, required this.frequency, required this.startDateTime, this.currentStreak = 0, this.maxStreak = 0, this.isActive = true})
      : id = const Uuid().v4();

  static DateTime findStartDateTime(DateTime currentDateTime,
      Frequency frequency, int hours, int minutes,
      {String? day, String? date}) {
    DateTime startDateTime;

    switch (frequency) {
      case Frequency.daily:
        startDateTime = DateTime(
          currentDateTime.year,
          currentDateTime.month,
          currentDateTime.day,
          hours,
          minutes,
        );
        if (startDateTime.isBefore(currentDateTime)) {
          startDateTime = startDateTime.add(const Duration(days: 1));
        }
        break;
      case Frequency.weekly:
        int targetWeekday = daysOfWeek.indexOf(day!);
        int currentWeekday = (currentDateTime.weekday - 1) % 7;
        int daysUntilTarget = (targetWeekday - currentWeekday + 7) % 7;
        startDateTime = DateTime(
          currentDateTime.year,
          currentDateTime.month,
          currentDateTime.day + daysUntilTarget,
          hours,
          minutes,
        );
        if (startDateTime.isBefore(currentDateTime)) {
          startDateTime = startDateTime.add(const Duration(days: 7));
        }
        break;
      case Frequency.monthly:
        DateTime parsedDate = DateTime.parse(date!);
        startDateTime = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          hours,
          minutes,
        );
        if (startDateTime.isBefore(currentDateTime)) {
          startDateTime = DateTime(
            parsedDate.year,
            parsedDate.month + 1,
            parsedDate.day,
            hours,
            minutes,
          );
        }
        break;
      case Frequency.yearly:
        DateTime parsedDate = DateTime.parse(date!);
        startDateTime = DateTime(
          currentDateTime.year,
          parsedDate.month,
          parsedDate.day,
          hours,
          minutes,
        );
        if (startDateTime.isBefore(currentDateTime)) {
          startDateTime = DateTime(
            currentDateTime.year + 1,
            parsedDate.month,
            parsedDate.day,
            hours,
            minutes,
          );
        }
        break;
      case Frequency.custom:
        startDateTime = DateTime(
          currentDateTime.year,
          currentDateTime.month,
          currentDateTime.day,
          hours,
          minutes,
        );
        break;
    }

    return startDateTime;
  }
}