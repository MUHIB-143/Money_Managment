import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 6)
class Reminder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime dateTime;

  @HiveField(4)
  String type; // payment, tuition, savings, custom

  @HiveField(5)
  String? relatedId; // ID of related transaction/goal/tuition

  @HiveField(6)
  bool isRecurring;

  @HiveField(7)
  String? repeatFrequency; // daily, weekly, monthly

  @HiveField(8)
  bool isCompleted;

  @HiveField(9)
  DateTime createdDate;

  Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.dateTime,
    this.type = 'custom',
    this.relatedId,
    this.isRecurring = false,
    this.repeatFrequency,
    this.isCompleted = false,
    required this.createdDate,
  });

  // Check if reminder is past due
  bool get isPastDue {
    return !isCompleted && DateTime.now().isAfter(dateTime);
  }

  // Check if reminder is today
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  // Check if reminder is upcoming (within next 7 days)
  bool get isUpcoming {
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    return dateTime.isAfter(now) && dateTime.isBefore(weekFromNow);
  }

  // Calculate next occurrence for recurring reminders
  DateTime? getNextOccurrence() {
    if (!isRecurring || repeatFrequency == null) return null;

    switch (repeatFrequency) {
      case 'daily':
        return dateTime.add(const Duration(days: 1));
      case 'weekly':
        return dateTime.add(const Duration(days: 7));
      case 'monthly':
        return DateTime(
          dateTime.year,
          dateTime.month + 1,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
        );
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'type': type,
      'relatedId': relatedId,
      'isRecurring': isRecurring,
      'repeatFrequency': repeatFrequency,
      'isCompleted': isCompleted,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      type: json['type'] ?? 'custom',
      relatedId: json['relatedId'],
      isRecurring: json['isRecurring'] ?? false,
      repeatFrequency: json['repeatFrequency'],
      isCompleted: json['isCompleted'] ?? false,
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}
