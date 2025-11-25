import 'package:hive/hive.dart';

part 'savings_goal_model.g.dart';

@HiveType(typeId: 2)
class SavingsGoal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name; // e.g., "New Laptop", "Trip to Bali"

  @HiveField(2)
  double targetAmount;

  @HiveField(3)
  double currentAmount;

  @HiveField(4)
  DateTime? deadline;

  @HiveField(5)
  DateTime createdDate;

  @HiveField(6)
  String? description;

  @HiveField(7)
  bool isCompleted;

  @HiveField(8)
  String? linkedTuitionId; // Link to TuitionFee if this is a tuition savings goal

  @HiveField(9)
  String goalType; // 'general', 'tuition', 'emergency', 'vacation', etc.

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.deadline,
    required this.createdDate,
    this.description,
    this.isCompleted = false,
    this.linkedTuitionId,
    this.goalType = 'general',
  });

  // Calculate progress percentage
  double get progressPercentage {
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount * 100).clamp(0, 100);
  }

  // Calculate remaining amount
  double get remainingAmount {
    return (targetAmount - currentAmount).clamp(0, double.infinity);
  }

  // Calculate days remaining
  int? get daysRemaining {
    if (deadline == null) return null;
    return deadline!.difference(DateTime.now()).inDays;
  }

  // Calculate suggested weekly savings
  double? get suggestedWeeklySavings {
    if (deadline == null || daysRemaining == null || daysRemaining! <= 0) return null;
    final weeksRemaining = daysRemaining! / 7;
    if (weeksRemaining <= 0) return remainingAmount;
    return remainingAmount / weeksRemaining;
  }

  // Calculate suggested monthly savings
  double? get suggestedMonthlySavings {
    if (deadline == null || daysRemaining == null || daysRemaining! <= 0) return null;
    final monthsRemaining = daysRemaining! / 30;
    if (monthsRemaining <= 0) return remainingAmount;
    return remainingAmount / monthsRemaining;
  }

  // Add to savings
  void addAmount(double amount) {
    currentAmount += amount;
    if (currentAmount >= targetAmount) {
      isCompleted = true;
    }
  }

  // Check if goal is overdue
  bool get isOverdue {
    if (deadline == null || isCompleted) return false;
    return DateTime.now().isAfter(deadline!);
  }

  // Check if this is a tuition goal
  bool get isTuitionGoal => goalType == 'tuition' && linkedTuitionId != null;

  // Factory method to create tuition savings goal
  factory SavingsGoal.forTuition({
    required String id,
    required String tuitionId,
    required String semester,
    required double targetAmount,
    DateTime? deadline,
    double currentAmount = 0.0,
  }) {
    return SavingsGoal(
      id: id,
      name: 'Tuition - $semester',
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      deadline: deadline,
      createdDate: DateTime.now(),
      description: 'Savings goal for $semester tuition fee',
      linkedTuitionId: tuitionId,
      goalType: 'tuition',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'description': description,
      'isCompleted': isCompleted,
      'linkedTuitionId': linkedTuitionId,
      'goalType': goalType,
    };
  }

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'],
      name: json['name'],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'] ?? 0.0,
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      createdDate: DateTime.parse(json['createdDate']),
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      linkedTuitionId: json['linkedTuitionId'],
      goalType: json['goalType'] ?? 'general',
    );
  }
}
