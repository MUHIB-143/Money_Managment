import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:managment/models/expense_model.dart';
import 'package:managment/providers/expense_provider.dart';
import 'package:managment/providers/settings_provider.dart';
import 'package:managment/theme/app_colors.dart';
import 'package:managment/utils/constants.dart';
import 'package:managment/utils/helpers.dart';
import 'package:managment/utils/validators.dart';
import 'package:managment/widgets/glassmorphism.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String _selectedPeriod = 'month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () => _showCategoryBreakdown(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(child: _buildExpenseList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
        double total;
        String periodLabel;

        switch (_selectedPeriod) {
          case 'today':
            total = provider.todayExpenses;
            periodLabel = 'Today';
            break;
          case 'week':
            total = provider.weekExpenses;
            periodLabel = 'This Week';
            break;
          case 'month':
            total = provider.monthExpenses;
            periodLabel = 'This Month';
            break;
          default:
            total = provider.totalExpenses;
            periodLabel = 'All Time';
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      periodLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list),
                      onSelected: (value) {
                        setState(() {
                          _selectedPeriod = value;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'today', child: Text('Today')),
                        const PopupMenuItem(value: 'week', child: Text('This Week')),
                        const PopupMenuItem(value: 'month', child: Text('This Month')),
                        const PopupMenuItem(value: 'all', child: Text('All Time')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  Helpers.formatCurrency(total, currencySymbol),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${provider.expenses.length} transactions',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseList() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        if (provider.expenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: AppColors.textSecondaryLight,
                ),
                const SizedBox(height: 16),
                Text(
                  'No expenses yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first expense',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: provider.expenses.length,
          itemBuilder: (context, index) {
            final expense = provider.expenses[index];
            return _buildExpenseItem(expense);
          },
        );
      },
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
    final dateFormat = context.watch<SettingsProvider>().dateFormat;

    return Dismissible(
      key: Key(expense.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<ExpenseProvider>().deleteExpense(expense.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.getExpenseCategoryColor(expense.category).withValues(alpha: 0.2),
            child: Icon(
              ExpenseCategories.getIcon(expense.category),
              color: AppColors.getExpenseCategoryColor(expense.category),
            ),
          ),
          title: Text(ExpenseCategories.getLabel(expense.category)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (expense.description != null) Text(expense.description!),
              Text(
                Helpers.formatDate(expense.date, dateFormat),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          trailing: Text(
            Helpers.formatCurrency(expense.amount, currencySymbol),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
          ),
          onTap: () => _showEditExpenseDialog(expense),
        ),
      ),
    );
  }

  void _showCategoryBreakdown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Consumer<ExpenseProvider>(
            builder: (context, provider, _) {
              final categoryData = provider.getMonthExpensesByCategory();
              final currencySymbol = context.watch<SettingsProvider>().currencySymbol;

              if (categoryData.isEmpty) {
                return Center(
                  child: Text(
                    'No expense data',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }

              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Category Breakdown',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sections: _getPieChartSections(categoryData),
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...categoryData.entries.map((entry) {
                    final total = categoryData.values.fold(0.0, (a, b) => a + b);
                    final percentage = (entry.value / total * 100);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.getExpenseCategoryColor(entry.key),
                        ),
                        title: Text(ExpenseCategories.getLabel(entry.key)),
                        subtitle: Text('${percentage.toStringAsFixed(1)}%'),
                        trailing: Text(
                          Helpers.formatCurrency(entry.value, currencySymbol),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections(Map<String, double> data) {
    final total = data.values.fold(0.0, (sum, value) => sum + value);

    return data.entries.map((entry) {
      final percentage = (entry.value / total * 100);
      final color = AppColors.getExpenseCategoryColor(entry.key);

      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        color: color,
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  void _showAddExpenseDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditExpenseScreen(),
      ),
    );
  }

  void _showEditExpenseDialog(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditExpenseScreen(expense: expense),
      ),
    );
  }
}

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddEditExpenseScreen({super.key, this.expense});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'food';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
      _descriptionController.text = widget.expense!.description ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExpenseCategories.categoryNames.map((category) {
                final isSelected = category == _selectedCategory;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        ExpenseCategories.getIcon(category),
                        size: 18,
                        color: isSelected ? Colors.white : null,
                      ),
                      const SizedBox(width: 4),
                      Text(ExpenseCategories.getLabel(category)),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    }
                  },
                  selectedColor: AppColors.getExpenseCategoryColor(category),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: Validators.validateAmount,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Date'),
              subtitle: Text(Helpers.formatDate(
                _selectedDate,
                context.watch<SettingsProvider>().dateFormat,
              )),
              leading: const Icon(Icons.calendar_today),
              onTap: _pickDate,
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
              onPressed: _saveExpense,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.error,
              ),
              child: Text(widget.expense == null ? 'Add Expense' : 'Update Expense'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: widget.expense?.id ?? Helpers.generateId(),
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      );

      if (widget.expense == null) {
        context.read<ExpenseProvider>().addExpense(expense);
      } else {
        context.read<ExpenseProvider>().updateExpense(expense);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.expense == null ? 'Expense added' : 'Expense updated'),
        ),
      );
    }
  }
}
