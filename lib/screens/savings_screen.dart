import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:managment/models/savings_goal_model.dart';
import 'package:managment/providers/savings_provider.dart';
import 'package:managment/providers/settings_provider.dart';
import 'package:managment/theme/app_colors.dart';
import 'package:managment/utils/helpers.dart';
import 'package:managment/utils/validators.dart';
import 'package:managment/widgets/glassmorphism.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
      ),
      body: Consumer<SavingsProvider>(
        builder: (context, provider, _) {
          if (provider.savingsGoals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.savings_outlined,
                    size: 64,
                    color: AppColors.textSecondaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No savings goals yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to create your first goal',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSummaryCard(provider, context),
              const SizedBox(height: 16),
              if (provider.activeGoals.isNotEmpty) ...[
                Text(
                  'Active Goals',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...provider.activeGoals.map((goal) => _buildGoalCard(context, goal)),
              ],
              if (provider.completedGoals.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Completed Goals',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...provider.completedGoals.map((goal) => _buildGoalCard(context, goal)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoalDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Goal'),
        backgroundColor: AppColors.neonTeal,
      ),
    );
  }

  Widget _buildSummaryCard(SavingsProvider provider, BuildContext context) {
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Saved',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            Helpers.formatCurrency(provider.totalSavings, currencySymbol),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonTeal,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${provider.activeGoals.length} active goals',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, SavingsGoal goal) {
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
    final dateFormat = context.watch<SettingsProvider>().dateFormat;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => _showEditGoalDialog(context, goal),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      goal.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (goal.isCompleted)
                    const Icon(Icons.check_circle, color: AppColors.success),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: goal.progressPercentage / 100,
                  minHeight: 8,
                  backgroundColor: AppColors.lightGray,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    goal.isCompleted ? AppColors.success : AppColors.neonTeal,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${Helpers.formatCurrency(goal.currentAmount, currencySymbol)} / ${Helpers.formatCurrency(goal.targetAmount, currencySymbol)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    '${goal.progressPercentage.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: goal.isCompleted ? AppColors.success : AppColors.neonTeal,
                        ),
                  ),
                ],
              ),
              if (goal.deadline != null && !goal.isCompleted) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: goal.isOverdue ? AppColors.error : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${Helpers.formatDate(goal.deadline!, dateFormat)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: goal.isOverdue ? AppColors.error : null,
                          ),
                    ),
                    if (goal.daysRemaining != null)
                      Text(
                        ' (${goal.daysRemaining} days)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: goal.isOverdue ? AppColors.error : AppColors.primaryBlue,
                            ),
                      ),
                  ],
                ),
              ],
              if (goal.suggestedWeeklySavings != null && !goal.isCompleted) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.info),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Save ${Helpers.formatCurrency(goal.suggestedWeeklySavings!, currencySymbol)}/week to reach your goal',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditSavingsGoalScreen(),
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, SavingsGoal goal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditSavingsGoalScreen(goal: goal),
      ),
    );
  }
}

class AddEditSavingsGoalScreen extends StatefulWidget {
  final SavingsGoal? goal;

  const AddEditSavingsGoalScreen({super.key, this.goal});

  @override
  State<AddEditSavingsGoalScreen> createState() => _AddEditSavingsGoalScreenState();
}

class _AddEditSavingsGoalScreenState extends State<AddEditSavingsGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _nameController.text = widget.goal!.name;
      _targetAmountController.text = widget.goal!.targetAmount.toString();
      _currentAmountController.text = widget.goal!.currentAmount.toString();
      _descriptionController.text = widget.goal!.description ?? '';
      _deadline = widget.goal!.deadline;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal == null ? 'Add Savings Goal' : 'Edit Savings Goal'),
        actions: widget.goal != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<SavingsProvider>().deleteSavingsGoal(widget.goal!.id);
                    Navigator.pop(context);
                  },
                ),
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Goal Name',
                hintText: 'e.g., New Laptop, Trip to Bali',
                prefixIcon: Icon(Icons.flag),
              ),
              validator: (value) => Validators.validateRequired(value, 'goal name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetAmountController,
              decoration: const InputDecoration(
                labelText: 'Target Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: Validators.validateAmount,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _currentAmountController,
              decoration: const InputDecoration(
                labelText: 'Current Amount',
                prefixIcon: Icon(Icons.savings),
              ),
              keyboardType: TextInputType.number,
              validator: Validators.validateAmount,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Deadline (Optional)'),
              subtitle: Text(
                _deadline != null
                    ? Helpers.formatDate(_deadline!, context.watch<SettingsProvider>().dateFormat)
                    : 'No deadline set',
              ),
              leading: const Icon(Icons.calendar_today),
              trailing: _deadline != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _deadline = null;
                        });
                      },
                    )
                  : null,
              onTap: _pickDeadline,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveGoal,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.neonTeal,
              ),
              child: Text(widget.goal == null ? 'Create Goal' : 'Update Goal'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() {
        _deadline = date;
      });
    }
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      final goal = SavingsGoal(
        id: widget.goal?.id ?? Helpers.generateId(),
        name: _nameController.text,
        targetAmount: double.parse(_targetAmountController.text),
        currentAmount: double.parse(_currentAmountController.text),
        deadline: _deadline,
        createdDate: widget.goal?.createdDate ?? DateTime.now(),
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        isCompleted: double.parse(_currentAmountController.text) >= double.parse(_targetAmountController.text),
      );

      if (widget.goal == null) {
        context.read<SavingsProvider>().addSavingsGoal(goal);
      } else {
        context.read<SavingsProvider>().updateSavingsGoal(goal);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.goal == null ? 'Goal created' : 'Goal updated'),
        ),
      );
    }
  }
}
