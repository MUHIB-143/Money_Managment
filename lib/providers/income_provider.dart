import 'package:flutter/foundation.dart';
import 'package:managment/models/income_model.dart';
import 'package:managment/services/database_service.dart';
import 'package:managment/utils/helpers.dart';

class IncomeProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List<Income> _incomes = [];
  
  List<Income> get incomes => _incomes;
  
  IncomeProvider() {
    loadIncomes();
  }
  
  // Load all incomes
  Future<void> loadIncomes() async {
    _incomes = _db.getAllIncomes();
    _incomes.sort((a, b) => b.date.compareTo(a.date)); // Sort by date, newest first
    notifyListeners();
  }
  
  // Add income
  Future<void> addIncome(Income income) async {
    await _db.addIncome(income);
    await loadIncomes();
  }
  
  // Update income
  Future<void> updateIncome(Income income) async {
    await _db.updateIncome(income);
    await loadIncomes();
  }
  
  // Delete income
  Future<void> deleteIncome(String id) async {
    await _db.deleteIncome(id);
    await loadIncomes();
  }
  
  // Get total income
  double get totalIncome => _db.getTotalIncome();
  
  // Get income for today
  double get todayIncome {
    final today = DateTime.now();
    final start = Helpers.getDayStart(today);
    final end = Helpers.getDayEnd(today);
    return _db.getTotalIncomeForPeriod(start, end);
  }
  
  // Get income for this week
  double get weekIncome {
    final today = DateTime.now();
    final start = Helpers.getWeekStart(today);
    final end = Helpers.getWeekEnd(today);
    return _db.getTotalIncomeForPeriod(start, end);
  }
  
  // Get income for this month
  double get monthIncome {
    final today = DateTime.now();
    final start = Helpers.getMonthStart(today);
    final end = Helpers.getMonthEnd(today);
    return _db.getTotalIncomeForPeriod(start, end);
  }
  
  // Get incomes for a specific period
  List<Income> getIncomesForPeriod(DateTime start, DateTime end) {
    return _incomes
        .where((income) =>
            income.date.isAfter(start.subtract(const Duration(days: 1))) &&
            income.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }
  
  // Get income by category
  Map<String, double> getIncomeByCategory() {
    Map<String, double> categoryTotals = {};
    for (var income in _incomes) {
      categoryTotals[income.category] =
          (categoryTotals[income.category] ?? 0) + income.amount;
    }
    return categoryTotals;
  }
}
