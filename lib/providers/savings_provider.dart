import 'package:flutter/foundation.dart';
import 'package:managment/models/savings_goal_model.dart';
import 'package:managment/services/database_service.dart';

class SavingsProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List<SavingsGoal> _savingsGoals = [];
  
  List<SavingsGoal> get savingsGoals => _savingsGoals;
  List<SavingsGoal> get activeGoals => _savingsGoals.where((g) => !g.isCompleted).toList();
  List<SavingsGoal> get completedGoals => _savingsGoals.where((g) => g.isCompleted).toList();
  
  SavingsProvider() {
    loadSavingsGoals();
  }
  
  Future<void> loadSavingsGoals() async {
    _savingsGoals = _db.getAllSavingsGoals();
    _savingsGoals.sort((a, b) => a.isCompleted.toString().compareTo(b.isCompleted.toString()));
    notifyListeners();
  }
  
  Future<void> addSavingsGoal(SavingsGoal goal) async {
    await _db.addSavingsGoal(goal);
    await loadSavingsGoals();
  }
  
  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    await _db.updateSavingsGoal(goal);
    await loadSavingsGoals();
  }
  
  Future<void> deleteSavingsGoal(String id) async {
    await _db.deleteSavingsGoal(id);
    await loadSavingsGoals();
  }
  
  double get totalSavings => _db.getTotalSavingsGoals();

  // Apply savings to tuition fee
  Future<void> applySavingsToTuition({
    required String savingsGoalId,
    required String tuitionId,
    required double amount,
  }) async {
    await _db.applySavingsToTuition(
      savingsGoalId: savingsGoalId,
      tuitionId: tuitionId,
      amount: amount,
    );
    await loadSavingsGoals();
  }

  // Get savings goals for a specific tuition
  List<SavingsGoal> getSavingsGoalsForTuition(String tuitionId) {
    return _savingsGoals.where((g) => g.linkedTuitionId == tuitionId).toList();
  }

  // Get tuition-specific goals
  List<SavingsGoal> get tuitionGoals => _savingsGoals.where((g) => g.isTuitionGoal).toList();
}
