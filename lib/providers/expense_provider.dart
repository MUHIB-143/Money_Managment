import 'package:flutter/foundation.dart';
import 'package:managment/models/expense_model.dart';
import 'package:managment/services/database_service.dart';
import 'package:managment/utils/helpers.dart';

class ExpenseProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List<Expense> _expenses = [];
  
  List<Expense> get expenses => _expenses;
  
  ExpenseProvider() {
    loadExpenses();
  }
  
  // Load all expenses
  Future<void> loadExpenses() async {
    _expenses = _db.getAllExpenses();
    _expenses.sort((a, b) => b.date.compareTo(a.date)); // Sort by date, newest first
    notifyListeners();
  }
  
  // Add expense
  Future<void> addExpense(Expense expense) async {
    await _db.addExpense(expense);
    await loadExpenses();
  }
  
  // Update expense
  Future<void> updateExpense(Expense expense) async {
    await _db.updateExpense(expense);
    await loadExpenses();
  }
  
  // Delete expense
  Future<void> deleteExpense(String id) async {
    await _db.deleteExpense(id);
    await loadExpenses();
  }
  
  // Get total expenses
  double get totalExpenses => _db.getTotalExpenses();
  
  // Get expenses for today
  double get todayExpenses {
    final today = DateTime.now();
    final start = Helpers.getDayStart(today);
    final end = Helpers.getDayEnd(today);
    return _db.getTotalExpensesForPeriod(start, end);
  }
  
  // Get expenses for this week
  double get weekExpenses {
    final today = DateTime.now();
    final start = Helpers.getWeekStart(today);
    final end = Helpers.getWeekEnd(today);
    return _db.getTotalExpensesForPeriod(start, end);
  }
  
  // Get expenses for this month
  double get monthExpenses {
    final today = DateTime.now();
    final start = Helpers.getMonthStart(today);
    final end = Helpers.getMonthEnd(today);
    return _db.getTotalExpensesForPeriod(start, end);
  }
  
  // Get expenses for a specific period
  List<Expense> getExpensesForPeriod(DateTime start, DateTime end) {
    return _expenses
        .where((expense) =>
            expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
            expense.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }
  
  // Get expenses by category
  Map<String, double> getExpensesByCategory({DateTime? start, DateTime? end}) {
    List<Expense> expensesToAnalyze = _expenses;
    
    if (start != null && end != null) {
      expensesToAnalyze = getExpensesForPeriod(start, end);
    }
    
    Map<String, double> categoryTotals = {};
    for (var expense in expensesToAnalyze) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }
  
  // Get month expenses by category
  Map<String, double> getMonthExpensesByCategory() {
    final today = DateTime.now();
    final start = Helpers.getMonthStart(today);
    final end = Helpers.getMonthEnd(today);
    return _db.getExpensesByCategory(start, end);
  }
}
