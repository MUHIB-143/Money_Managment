import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String category; // food, transport, entertainment, education, bills, health, shopping, other

  @HiveField(4)
  String? description;

  @HiveField(5)
  String? budgetId; // Link to budget if applicable

  Expense({
    required this.id,
    required this.amount,
    required this.date,
    required this.category,
    this.description,
    this.budgetId,
  });

  // Helper to get total expenses for a period
  static double getTotalForPeriod(List<Expense> expenses, DateTime start, DateTime end) {
    return expenses
        .where((expense) => expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
            expense.date.isBefore(end.add(const Duration(days: 1))))
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get total by category
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }

  // Check if expense is from this month
  bool isFromThisMonth() {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Check if expense is from this week
  bool isFromThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  // Check if expense is from today
  bool isFromToday() {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
      'budgetId': budgetId,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      description: json['description'],
      budgetId: json['budgetId'],
    );
  }
}
