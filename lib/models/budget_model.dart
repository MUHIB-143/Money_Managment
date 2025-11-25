import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 5)
class Budget extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String category; // matches expense categories

  @HiveField(2)
  double allocatedAmount;

  @HiveField(3)
  String period; // daily, weekly, monthly

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime? endDate;

  @HiveField(6)
  bool isActive;

  Budget({
    required this.id,
    required this.category,
    required this.allocatedAmount,
    this.period = 'monthly',
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  // Calculate spent amount (needs to be passed from expense data)
  double getSpentPercentage(double spentAmount) {
    if (allocatedAmount == 0) return 0;
    return (spentAmount / allocatedAmount * 100).clamp(0, double.infinity);
  }

  // Check if budget is exceeded
  bool isExceeded(double spentAmount) {
    return spentAmount > allocatedAmount;
  }

  // Get remaining amount
  double getRemainingAmount(double spentAmount) {
    return (allocatedAmount - spentAmount).clamp(0, double.infinity);
  }

  // Check if budget is currently active based on period
  bool get isCurrentlyActive {
    if (!isActive) return false;
    
    final now = DateTime.now();
    if (endDate != null && now.isAfter(endDate!)) return false;
    
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'allocatedAmount': allocatedAmount,
      'period': period,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category'],
      allocatedAmount: json['allocatedAmount'],
      period: json['period'] ?? 'monthly',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'] ?? true,
    );
  }
}
