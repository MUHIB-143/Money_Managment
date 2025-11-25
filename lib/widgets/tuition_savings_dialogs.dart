import 'package:flutter/material.dart';
import 'package:managment/models/savings_goal_model.dart';
import 'package:managment/models/tuition_fee_model.dart';
import 'package:managment/theme/app_colors.dart';
import 'package:managment/widgets/glassmorphism.dart';
import 'package:managment/utils/helpers.dart';
import 'package:managment/utils/spacing.dart';

/// Dialog to create a savings goal for tuition
class CreateTuitionGoalDialog extends StatelessWidget {
  final TuitionFee tuition;
  final Function(SavingsGoal) onCreateGoal;

  const CreateTuitionGoalDialog({
    super.key,
    required this.tuition,
    required this.onCreateGoal,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Savings Goal'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a savings goal to help cover your ${tuition.semester} tuition fee?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            GlassCard(
              elevation: GlassElevation.low,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    'Goal Name',
                    'Tuition - ${tuition.semester}',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoRow(
                    context,
                    'Target Amount',
                    Helpers.formatCurrency(tuition.remainingBalance, '\$'),
                    valueColor: AppColors.primaryBlue,
                  ),
                  if (tuition.dueDate != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildInfoRow(
                      context,
                      'Deadline',
                      Helpers.formatDate(tuition.dueDate!, 'MMM dd, yyyy'),
                    ),
                  ],
                  if (tuition.suggestedWeeklySavings != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Divider(),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Suggested Savings',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${Helpers.formatCurrency(tuition.suggestedWeeklySavings!, '\$')}/week',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final goal = SavingsGoal.forTuition(
              id: Helpers.generateId(),
              tuitionId: tuition.id,
              semester: tuition.semester,
              targetAmount: tuition.remainingBalance,
              deadline: tuition.dueDate,
            );
            onCreateGoal(goal);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('Create Goal'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}

/// Dialog to pay tuition from savings
class PayFromSavingsDialog extends StatefulWidget {
  final TuitionFee tuition;
  final List<SavingsGoal> availableGoals;
  final Function(String savingsGoalId, double amount) onPay;

  const PayFromSavingsDialog({
    super.key,
    required this.tuition,
    required this.availableGoals,
    required this.onPay,
  });

  @override
  State<PayFromSavingsDialog> createState() => _PayFromSavingsDialogState();
}

class _PayFromSavingsDialogState extends State<PayFromSavingsDialog> {
  SavingsGoal? _selectedGoal;
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pay from Savings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a savings goal to use for payment:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Savings goal selector
            ...widget.availableGoals.map((goal) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGoal = goal;
                    // Pre-fill with max possible amount
                    final maxAmount = goal.currentAmount < widget.tuition.remainingBalance
                        ? goal.currentAmount
                        : widget.tuition.remainingBalance;
                    _amountController.text = maxAmount.toStringAsFixed(2);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _selectedGoal?.id == goal.id
                        ? AppColors.primaryBlue.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: _selectedGoal?.id == goal.id
                          ? AppColors.primaryBlue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        goal.isTuitionGoal ? Icons.school : Icons.savings,
                        color: _selectedGoal?.id == goal.id
                            ? AppColors.primaryBlue
                            : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.name,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Available: ${Helpers.formatCurrency(goal.currentAmount, '\$')}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (_selectedGoal?.id == goal.id)
                        const Icon(Icons.check_circle, color: AppColors.success),
                    ],
                  ),
                ),
              );
            }).toList(),

            if (widget.availableGoals.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Icon(
                      Icons.savings_outlined,
                      size: 48,
                      color: AppColors.textSecondaryLight,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'No savings goals with funds available',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            if (_selectedGoal != null) ...[
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount to Pay',
                  prefixText: '\$ ',
                  helperText: 'Max: ${Helpers.formatCurrency(_selectedGoal!.currentAmount, '\$')}',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _selectedGoal == null || widget.availableGoals.isEmpty
              ? null
              : () {
                  final amount = double.tryParse(_amountController.text) ?? 0;
                  if (amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid amount')),
                    );
                    return;
                  }
                  if (amount > _selectedGoal!.currentAmount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Amount exceeds available savings')),
                    );
                    return;
                  }
                  widget.onPay(_selectedGoal!.id, amount);
                  Navigator.pop(context);
                },
          icon: const Icon(Icons.payment),
          label: const Text('Pay Now'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
          ),
        ),
      ],
    );
  }
}
