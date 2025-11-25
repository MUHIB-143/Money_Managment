import 'package:flutter/foundation.dart';
import 'package:managment/models/tuition_fee_model.dart';
import 'package:managment/models/savings_goal_model.dart';
import 'package:managment/services/database_service.dart';

class TuitionProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List<TuitionFee> _tuitionFees = [];
  
  List<TuitionFee> get tuitionFees => _tuitionFees;
  List<TuitionFee> get unpaidFees => _tuitionFees.where((t) => !t.isFullyPaid).toList();
  
  TuitionProvider() {
    loadTuitionFees();
  }
  
  Future<void> loadTuitionFees() async {
    _tuitionFees = _db.getAllTuitionFees();
    _tuitionFees.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    notifyListeners();
  }
  
  Future<void> addTuitionFee(TuitionFee tuition) async {
    await _db.addTuitionFee(tuition);
    await loadTuitionFees();
  }
  
  Future<void> updateTuitionFee(TuitionFee tuition) async {
    await _db.updateTuitionFee(tuition);
    await loadTuitionFees();
  }
  
  Future<void> deleteTuitionFee(String id) async {
    await _db.deleteTuitionFee(id);
    await loadTuitionFees();
  }
  
  double get totalDue => _db.getTotalTuitionDue();

  // Get linked savings goals for a tuition
  List<SavingsGoal> getLinkedSavingsGoals(String tuitionId) {
    return _db.getSavingsGoalsForTuition(tuitionId);
  }

  // Get total savings allocated for a tuition
  double getTotalSavingsForTuition(String tuitionId) {
    return _db.getTotalSavingsForTuition(tuitionId);
  }
}
