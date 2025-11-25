import 'package:hive_flutter/hive_flutter.dart';
import 'package:managment/models/income_model.dart';
import 'package:managment/models/expense_model.dart';
import 'package:managment/models/savings_goal_model.dart';
import 'package:managment/models/tuition_fee_model.dart';
import 'package:managment/models/budget_model.dart';
import 'package:managment/models/reminder_model.dart';
import 'package:managment/utils/constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Boxes
  late Box<Income> _incomeBox;
  late Box<Expense> _expenseBox;
  late Box<SavingsGoal> _savingsGoalBox;
  late Box<TuitionFee> _tuitionFeeBox;
  late Box<Budget> _budgetBox;
  late Box<Reminder> _reminderBox;

  // Initialize Hive and boxes
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters - must match typeId in models
    Hive.registerAdapter(IncomeAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(SavingsGoalAdapter());
    Hive.registerAdapter(TuitionPaymentAdapter());
    Hive.registerAdapter(TuitionFeeAdapter());
    Hive.registerAdapter(BudgetAdapter());
    Hive.registerAdapter(ReminderAdapter());

    // Open boxes
    _incomeBox = await Hive.openBox<Income>(HiveBoxes.incomeBox);
    _expenseBox = await Hive.openBox<Expense>(HiveBoxes.expenseBox);
    _savingsGoalBox = await Hive.openBox<SavingsGoal>(HiveBoxes.savingsGoalBox);
    _tuitionFeeBox = await Hive.openBox<TuitionFee>(HiveBoxes.tuitionFeeBox);
    _budgetBox = await Hive.openBox<Budget>(HiveBoxes.budgetBox);
    _reminderBox = await Hive.openBox<Reminder>(HiveBoxes.reminderBox);
  }

  // ========== INCOME OPERATIONS ==========

  Future<void> addIncome(Income income) async {
    await _incomeBox.put(income.id, income);
  }

  Future<void> updateIncome(Income income) async {
    await _incomeBox.put(income.id, income);
  }

  Future<void> deleteIncome(String id) async {
    await _incomeBox.delete(id);
  }

  Income? getIncome(String id) {
    return _incomeBox.get(id);
  }

  List<Income> getAllIncomes() {
    return _incomeBox.values.toList();
  }

  List<Income> getIncomesForPeriod(DateTime start, DateTime end) {
    return _incomeBox.values
        .where((income) =>
            income.date.isAfter(start.subtract(const Duration(days: 1))) &&
            income.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  double getTotalIncome() {
    return _incomeBox.values.fold(0.0, (sum, income) => sum + income.amount);
  }

  double getTotalIncomeForPeriod(DateTime start, DateTime end) {
    return getIncomesForPeriod(start, end)
        .fold(0.0, (sum, income) => sum + income.amount);
  }

  // ========== EXPENSE OPERATIONS ==========

  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  Future<void> updateExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }

  Expense? getExpense(String id) {
    return _expenseBox.get(id);
  }

  List<Expense> getAllExpenses() {
    return _expenseBox.values.toList();
  }

  List<Expense> getExpensesForPeriod(DateTime start, DateTime end) {
    return _expenseBox.values
        .where((expense) =>
            expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
            expense.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  double getTotalExpenses() {
    return _expenseBox.values.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getTotalExpensesForPeriod(DateTime start, DateTime end) {
    return getExpensesForPeriod(start, end)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> getExpensesByCategory(DateTime start, DateTime end) {
    final expenses = getExpensesForPeriod(start, end);
    Map<String, double> categoryTotals = {};
    
    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    
    return categoryTotals;
  }

  // ========== SAVINGS GOAL OPERATIONS ==========

  Future<void> addSavingsGoal(SavingsGoal goal) async {
    await _savingsGoalBox.put(goal.id, goal);
  }

  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    await _savingsGoalBox.put(goal.id, goal);
  }

  Future<void> deleteSavingsGoal(String id) async {
    await _savingsGoalBox.delete(id);
  }

  SavingsGoal? getSavingsGoal(String id) {
    return _savingsGoalBox.get(id);
  }

  List<SavingsGoal> getAllSavingsGoals() {
    return _savingsGoalBox.values.toList();
  }

  List<SavingsGoal> getActiveSavingsGoals() {
    return _savingsGoalBox.values.where((goal) => !goal.isCompleted).toList();
  }

  List<SavingsGoal> getCompletedSavingsGoals() {
    return _savingsGoalBox.values.where((goal) => goal.isCompleted).toList();
  }

  double getTotalSavingsGoals() {
    return _savingsGoalBox.values
        .fold(0.0, (sum, goal) => sum + goal.currentAmount);
  }

  // ========== TUITION FEE OPERATIONS ==========

  Future<void> addTuitionFee(TuitionFee tuition) async {
    await _tuitionFeeBox.put(tuition.id, tuition);
  }

  Future<void> updateTuitionFee(TuitionFee tuition) async {
    await _tuitionFeeBox.put(tuition.id, tuition);
  }

  Future<void> deleteTuitionFee(String id) async {
    await _tuitionFeeBox.delete(id);
  }

  TuitionFee? getTuitionFee(String id) {
    return _tuitionFeeBox.get(id);
  }

  List<TuitionFee> getAllTuitionFees() {
    return _tuitionFeeBox.values.toList();
  }

  List<TuitionFee> getUnpaidTuitionFees() {
    return _tuitionFeeBox.values.where((tuition) => !tuition.isFullyPaid).toList();
  }

  double getTotalTuitionDue() {
    return _tuitionFeeBox.values
        .fold(0.0, (sum, tuition) => sum + tuition.remainingBalance);
  }

  // ========== BUDGET OPERATIONS ==========

  Future<void> addBudget(Budget budget) async {
    await _budgetBox.put(budget.id, budget);
  }

  Future<void> updateBudget(Budget budget) async {
    await _budgetBox.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _budgetBox.delete(id);
  }

  Budget? getBudget(String id) {
    return _budgetBox.get(id);
  }

  List<Budget> getAllBudgets() {
    return _budgetBox.values.toList();
  }

  List<Budget> getActiveBudgets() {
    return _budgetBox.values.where((budget) => budget.isActive).toList();
  }

  Budget? getBudgetForCategory(String category) {
    try {
      return _budgetBox.values.firstWhere(
        (budget) => budget.category == category && budget.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  // ========== REMINDER OPERATIONS ==========

  Future<void> addReminder(Reminder reminder) async {
    await _reminderBox.put(reminder.id, reminder);
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _reminderBox.put(reminder.id, reminder);
  }

  Future<void> deleteReminder(String id) async {
    await _reminderBox.delete(id);
  }

  Reminder? getReminder(String id) {
    return _reminderBox.get(id);
  }

  List<Reminder> getAllReminders() {
    return _reminderBox.values.toList();
  }

  List<Reminder> getActiveReminders() {
    return _reminderBox.values.where((reminder) => !reminder.isCompleted).toList();
  }

  List<Reminder> getUpcomingReminders() {
    return _reminderBox.values.where((reminder) => reminder.isUpcoming && !reminder.isCompleted).toList();
  }

  List<Reminder> getPastDueReminders() {
    return _reminderBox.values.where((reminder) => reminder.isPastDue).toList();
  }

  // ========== DASHBOARD AGGREGATIONS ==========

  double getCurrentBalance() {
    return getTotalIncome() - getTotalExpenses();
  }

  Map<String, double> getMonthlyTrend(int months) {
    final now = DateTime.now();
    Map<String, double> trend = {};

    for (int i = months - 1; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthStart = DateTime(monthDate.year, monthDate.month, 1);
      final monthEnd = DateTime(monthDate.year, monthDate.month + 1, 0, 23, 59, 59);
      
      final income = getTotalIncomeForPeriod(monthStart, monthEnd);
      final expenses = getTotalExpensesForPeriod(monthStart, monthEnd);
      final key = '${monthDate.year}-${monthDate.month.toString().padLeft(2, '0')}';
      
      trend[key] = income - expenses;
    }

    return trend;
  }

  // ========== DATA EXPORT ==========

  Map<String, dynamic> exportAllData() {
    return {
      'incomes': _incomeBox.values.map((i) => i.toJson()).toList(),
      'expenses': _expenseBox.values.map((e) => e.toJson()).toList(),
      'savingsGoals': _savingsGoalBox.values.map((s) => s.toJson()).toList(),
      'tuitionFees': _tuitionFeeBox.values.map((t) => t.toJson()).toList(),
      'budgets': _budgetBox.values.map((b) => b.toJson()).toList(),
      'reminders': _reminderBox.values.map((r) => r.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // ========== DATA CLEAR ==========

  Future<void> clearAllData() async {
    await _incomeBox.clear();
    await _expenseBox.clear();
    await _savingsGoalBox.clear();
    await _tuitionFeeBox.clear();
    await _budgetBox.clear();
    await _reminderBox.clear();
  }

  // ========== TUITION-SAVINGS INTEGRATION ==========

  /// Apply savings from a goal to a tuition fee payment
  Future<void> applySavingsToTuition({
    required String savingsGoalId,
    required String tuitionId,
    required double amount,
  }) async {
    final savingsGoal = getSavingsGoal(savingsGoalId);
    final tuition = getTuitionFee(tuitionId);

    if (savingsGoal == null || tuition == null) {
      throw Exception('Savings goal or tuition fee not found');
    }

    if (savingsGoal.currentAmount < amount) {
      throw Exception('Insufficient savings balance');
    }

    // Deduct from savings
    savingsGoal.currentAmount -= amount;
    if (savingsGoal.currentAmount <= 0) {
      savingsGoal.currentAmount = 0;
    }

    // Add payment to tuition with special marker
    final payment = TuitionPayment(
      amount: amount,
      date: DateTime.now(),
      receipt: 'SAVINGS_TRANSFER_${savingsGoal.id}',
    );
    tuition.addPayment(payment);

    // Update both records
    await updateSavingsGoal(savingsGoal);
    await updateTuitionFee(tuition);
  }

  /// Get all savings goals linked to a specific tuition
  List<SavingsGoal> getSavingsGoalsForTuition(String tuitionId) {
    return _savingsGoalBox.values
        .where((goal) => goal.linkedTuitionId == tuitionId)
        .toList();
  }

  /// Get total savings allocated for a tuition fee
  double getTotalSavingsForTuition(String tuitionId) {
    return getSavingsGoalsForTuition(tuitionId)
        .fold(0.0, (sum, goal) => sum + goal.currentAmount);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
