# Tuition-Savings Integration

## 🎓 Feature Overview

Link savings goals to tuition fees to help students save systematically for their education costs. This integration allows:

1. **Auto-Create Savings Goals** from tuition fees
2. **Track Progress** toward tuition payment deadlines
3. **Apply Savings** directly to tuition payments
4. **Smart Suggestions** for weekly/monthly savings targets

---

## 📋 How to Use

### For Users

#### 1. Create a Tuition-Linked Savings Goal

**Option A: When Adding Tuition**
1. Go to Tuition screen → Tap "Add Tuition"
2. Enter tuition details (amount, semester, deadline)
3. Tap "Create Savings Goal" button
4. Auto-filled goal is created with:
   - Name: "Tuition - {semester}"
   - Target: Remaining tuition balance
   - Deadline: Tuition due date

**Option B: Manually from Savings Screen**
1. Go to Savings screen → Tap "Add Goal"
2. Select goal type: "Tuition"
3. Link to existing tuition fee
4. Set target amount and deadline

#### 2. Track Your Progress

**On Tuition Screen:**
- See "Linked Savings" card showing progress
- View suggested weekly/monthly savings amounts
- Track total savings allocated to tuition

**On Savings Screen:**
- Tuition goals show school icon badge
- Quick view of tuition semester and deadline
- Progress bar toward tuition target

#### 3. Pay Tuition from Savings

1. Go to Tuition screen
2<br>. Select a tuition fee
3. Tap "Pay from Savings" button
4. Choose which savings goal to use
5. Enter amount to transfer
6. Confirm payment

The amount is:
- Deducted from your savings goal
- Added as a tuition payment
- Marked with "SAVINGS_TRANSFER" receipt

---

## 💻 Developer Integration

### Using the Dialogs

```dart
import 'package:managment/widgets/tuition_savings_dialogs.dart';

// Show create goal dialog
showDialog(
  context: context,
  builder: (context) => CreateTuitionGoalDialog(
    tuition: tuitionFee,
    onCreateGoal: (goal) async {
      await savingsProvider.addSavingsGoal(goal);
      // Show success feedback
    },
  ),
);

// Show pay from savings dialog
final availableGoals = savingsProvider.savingsGoals
    .where((g) => g.currentAmount > 0)
    .toList();

showDialog(
  context: context,
  builder: (context) => PayFromSavingsDialog(
    tuition: tuitionFee,
    availableGoals: availableGoals,
    onPay: (savingsGoalId, amount) async {
      try {
        await savingsProvider.applySavingsToTuition(
          savingsGoalId: savingsGoalId,
          tuitionId: tuitionFee.id,
          amount: amount,
        );
        await tuitionProvider.loadTuitionFees();
        // Show success message
      } catch (e) {
        // Handle error
      }
    },
  ),
);
```

### Provider Methods

```dart
// SavingsProvider
await savingsProvider.applySavingsToTuition(
  savingsGoalId: 'goal_123',
  tuitionId: 'tuition_456',
  amount: 500.0,
);

List<SavingsGoal> tuitionGoals = savingsProvider.tuitionGoals;
List<SavingsGoal> goals = savingsProvider.getSavingsGoalsForTuition('tuition_456');

// TuitionProvider
List<SavingsGoal> linkedGoals = tuitionProvider.getLinkedSavingsGoals('tuition_456');
double totalSavings = tuitionProvider.getTotalSavingsForTuition('tuition_456');
```

### Creating Tuition Goals Programmatically

```dart
// Using factory constructor
final goal = SavingsGoal.forTuition(
  id: Helpers.generateId(),
  tuitionId: tuition.id,
  semester: tuition.semester,
  targetAmount: tuition.remainingBalance,
  deadline: tuition.dueDate,
  currentAmount: 0.0, // optional
);

await savingsProvider.addSavingsGoal(goal);
```

---

## 🔧 Technical Details

### Model Changes

**SavingsGoal**
- Added `linkedTuitionId` (String?) - Links to TuitionFee.id
- Added `goalType` (String) - 'general', 'tuition', etc.
- Added `isTuitionGoal` getter
- Added `SavingsGoal.forTuition()` factory

**TuitionFee**
- Added `suggestedWeeklySavings` getter
- Added `suggestedMonthlySavings` getter
- Added `hasPaymentFromSavings()` method

### Database Methods

```dart
// DatabaseService
Future<void> applySavingsToTuition({
  required String savingsGoalId,
  required String tuitionId,
  required double amount,
});

List<SavingsGoal> getSavingsGoalsForTuition(String tuitionId);
double getTotalSavingsForTuition(String tuitionId);
```

### Payment Tracking

Payments from savings are marked with a special receipt format:
```
SAVINGS_TRANSFER_{savingsGoalId}
```

This allows tracking which payments came from savings vs. other sources.

---

## 📊 Example Workflow

**Scenario**: Student needs $5,000 for Fall 2024 tuition, due in 12 weeks

1. **Add Tuition**
   - Enter $5,000 total
   - Set semester: "Fall 2024"
   - Set due date: 12 weeks from now
   - Tap "Create Savings Goal"

2. **Auto-Calculated Goal**
   - Name: "Tuition - Fall 2024"
   - Target: $5,000
   - Suggested: $417/week

3. **Track Progress**
   - User saves $500/week from part-time job
   - Allocates $417 to tuition goal each week
   - Watches progress bar increase

4. **Pay Tuition**
   - After 10 weeks: $4,170 saved
   - Tap "Pay from Savings"
   - Transfer $4,170 to tuition
   - Remaining: $830 (paid other ways)

5. **Goal Updates**
   - Savings goal: $0 current / $5,000 target
   - Tuition: $4,170 paid / $5,000 total
   - Status: In progress

---

## ✅ Benefits

- **Clear Targets**: Know exactly how much to save
- **Automated Suggestions**: Weekly/monthly goals calculated automatically
- **Easy Tracking**: See progress in one place
- **Flexible Payment**: Use any savings goal for any tuition
- **Motivation**: Visual progress bars encourage saving
- **Accountability**: Linked goals remind you of upcoming deadlines

---

## 🚀 Future Enhancements

Potential additions:
- Auto-allocate income to tuition goals
- Notifications when tuition deadline approaches
- Multiple payment installment planning
- Export tuition payment history
- Scholarship tracking integration

---

**Integration Complete!** Students can now systematically save for tuition fees with clear targets and easy payment flows. 🎓💰
