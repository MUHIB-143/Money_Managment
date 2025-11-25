import 'package:hive/hive.dart';

part 'tuition_fee_model.g.dart';

@HiveType(typeId: 3)
class TuitionPayment {
  @HiveField(0)
  double amount;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String? receipt;

  TuitionPayment({
    required this.amount,
    required this.date,
    this.receipt,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'receipt': receipt,
    };
  }

  factory TuitionPayment.fromJson(Map<String, dynamic> json) {
    return TuitionPayment(
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      receipt: json['receipt'],
    );
  }
}

@HiveType(typeId: 4)
class TuitionFee extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double totalAmount;

  @HiveField(2)
  List<TuitionPayment> payments;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  String semester; // e.g., "Fall 2024", "Spring 2025"

  @HiveField(5)
  String? institution;

  @HiveField(6)
  DateTime createdDate;

  TuitionFee({
    required this.id,
    required this.totalAmount,
    List<TuitionPayment>? payments,
    this.dueDate,
    required this.semester,
    this.institution,
    required this.createdDate,
  }) : payments = payments ?? [];

  // Calculate total paid
  double get totalPaid {
    return payments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  // Calculate remaining balance
  double get remainingBalance {
    return (totalAmount - totalPaid).clamp(0, double.infinity);
  }

  // Calculate payment progress percentage
  double get progressPercentage {
    if (totalAmount == 0) return 100;
    return (totalPaid / totalAmount * 100).clamp(0, 100);
  }

  // Check if fully paid
  bool get isFullyPaid {
    return remainingBalance == 0;
  }

  // Check if payment is overdue
  bool get isOverdue {
    if (dueDate == null || isFullyPaid) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  // Days until due date
  int? get daysUntilDue {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  // Add a payment
  void addPayment(TuitionPayment payment) {
    payments.add(payment);
  }

  // Helper method to check if payment is from savings
  // (To be used with payment descriptions/receipts)
  bool hasPaymentFromSavings() {
    return payments.any((p) => p.receipt?.contains('SAVINGS') ?? false);
  }

  // Calculate suggested savings based on deadline
  double? get suggestedWeeklySavings {
    if (dueDate == null || daysUntilDue == null || daysUntilDue! <= 0) return null;
    final weeksRemaining = daysUntilDue! / 7;
    if (weeksRemaining <= 0) return remainingBalance;
    return remainingBalance / weeksRemaining;
  }

  double? get suggestedMonthlySavings {
    if (dueDate == null || daysUntilDue == null || daysUntilDue! <= 0) return null;
    final monthsRemaining = daysUntilDue! / 30;
    if (monthsRemaining <= 0) return remainingBalance;
    return remainingBalance / monthsRemaining;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'payments': payments.map((p) => p.toJson()).toList(),
      'dueDate': dueDate?.toIso8601String(),
      'semester': semester,
      'institution': institution,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory TuitionFee.fromJson(Map<String, dynamic> json) {
    return TuitionFee(
      id: json['id'],
      totalAmount: json['totalAmount'],
      payments: (json['payments'] as List?)
              ?.map((p) => TuitionPayment.fromJson(p))
              .toList() ??
          [],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      semester: json['semester'],
      institution: json['institution'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}
