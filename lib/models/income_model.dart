import 'package:hive/hive.dart';

part 'income_model.g.dart';

@HiveType(typeId: 0)
class Income extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String source; // e.g., "Part-time Job", "Freelance", "Scholarship"

  @HiveField(4)
  String category; // hourly, freelance, scholarship, other

  @HiveField(5)
  double? hourlyRate; // For hourly income tracking

  @HiveField(6)
  double? hoursWorked; // For hourly income

  @HiveField(7)
  String? description;

  Income({
    required this.id,
    required this.amount,
    required this.date,
    required this.source,
    this.category = 'other',
    this.hourlyRate,
    this.hoursWorked,
    this.description,
  });

  // Calculate income if hourly
  static double calculateHourlyIncome(double rate, double hours) {
    return rate * hours;
  }

  // Helper to get period totals
  static double getTotalForPeriod(List<Income> incomes, DateTime start, DateTime end) {
    return incomes
        .where((income) => income.date.isAfter(start.subtract(const Duration(days: 1))) &&
            income.date.isBefore(end.add(const Duration(days: 1))))
        .fold(0.0, (sum, income) => sum + income.amount);
  }

  // Check if income is from this month
  bool isFromThisMonth() {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Check if income is from this week
  bool isFromThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  // Check if income is from today
  bool isFromToday() {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'source': source,
      'category': category,
      'hourlyRate': hourlyRate,
      'hoursWorked': hoursWorked,
      'description': description,
    };
  }

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      source: json['source'],
      category: json['category'] ?? 'other',
      hourlyRate: json['hourlyRate'],
      hoursWorked: json['hoursWorked'],
      description: json['description'],
    );
  }
}
