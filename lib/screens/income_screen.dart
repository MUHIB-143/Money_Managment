import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:managment/models/income_model.dart';
import 'package:managment/providers/income_provider.dart';
import 'package:managment/providers/settings_provider.dart';
import 'package:managment/theme/app_colors.dart';
import 'package:managment/utils/constants.dart';
import 'package:managment/utils/helpers.dart';
import 'package:managment/utils/validators.dart';
import 'package:managment/widgets/glassmorphism.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  String _selectedPeriod = 'month'; // today, week, month, all

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(child: _buildIncomeList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddIncomeDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Income'),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Consumer<IncomeProvider>(
      builder: (context, provider, _) {
        final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
        double total;
        String periodLabel;

        switch (_selectedPeriod) {
          case 'today':
            total = provider.todayIncome;
            periodLabel = 'Today';
            break;
          case 'week':
            total = provider.weekIncome;
            periodLabel = 'This Week';
            break;
          case 'month':
            total = provider.monthIncome;
            periodLabel = 'This Month';
            break;
          default:
            total = provider.totalIncome;
            periodLabel = 'All Time';
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  periodLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  Helpers.formatCurrency(total, currencySymbol),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${provider.incomes.length} transactions',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncomeList() {
    return Consumer<IncomeProvider>(
      builder: (context, provider, _) {
        if (provider.incomes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                  color: AppColors.textSecondaryLight,
                ),
                const SizedBox(height: 16),
                Text(
                  'No income entries yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first income',
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
          itemCount: provider.incomes.length,
          itemBuilder: (context, index) {
            final income = provider.incomes[index];
            return _buildIncomeItem(income);
          },
        );
      },
    );
  }

  Widget _buildIncomeItem(Income income) {
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
    final dateFormat = context.watch<SettingsProvider>().dateFormat;

    return Dismissible(
      key: Key(income.id),
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
        context.read<IncomeProvider>().deleteIncome(income.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Income deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.getIncomeCategoryColor(income.category).withValues(alpha: 0.2),
            child: Icon(
              IncomeCategories.getIcon(income.category),
              color: AppColors.getIncomeCategoryColor(income.category),
            ),
          ),
          title: Text(income.source),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(IncomeCategories.getLabel(income.category)),
              Text(
                Helpers.formatDate(income.date, dateFormat),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (income.hourlyRate != null && income.hoursWorked != null)
                Text(
                  '${income.hoursWorked}h @ ${Helpers.formatCurrency(income.hourlyRate!, currencySymbol)}/h',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                ),
            ],
          ),
          trailing: Text(
            Helpers.formatCurrency(income.amount, currencySymbol),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
          ),
          onTap: () => _showEditIncomeDialog(income),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Period'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Today', 'today'),
            _buildFilterOption('This Week', 'week'),
            _buildFilterOption('This Month', 'month'),
            _buildFilterOption('All Time', 'all'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _selectedPeriod,
      onChanged: (val) {
        setState(() {
          _selectedPeriod = val!;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showAddIncomeDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditIncomeScreen(),
      ),
    );
  }

  void _showEditIncomeDialog(Income income) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditIncomeScreen(income: income),
      ),
    );
  }
}

class AddEditIncomeScreen extends StatefulWidget {
  final Income? income;

  const AddEditIncomeScreen({super.key, this.income});

  @override
  State<AddEditIncomeScreen> createState() => _AddEditIncomeScreenState();
}

class _AddEditIncomeScreenState extends State<AddEditIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _sourceController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _hoursWorkedController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'other';
  DateTime _selectedDate = DateTime.now();
  bool _isHourlyIncome = false;

  @override
  void initState() {
    super.initState();
    if (widget.income != null) {
      _amountController.text = widget.income!.amount.toString();
      _sourceController.text = widget.income!.source;
      _selectedCategory = widget.income!.category;
      _selectedDate = widget.income!.date;
      _descriptionController.text = widget.income!.description ?? '';

      if (widget.income!.hourlyRate != null && widget.income!.hoursWorked != null) {
        _isHourlyIncome = true;
        _hourlyRateController.text = widget.income!.hourlyRate.toString();
        _hoursWorkedController.text = widget.income!.hoursWorked.toString();
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _sourceController.dispose();
    _hourlyRateController.dispose();
    _hoursWorkedController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.income == null ? 'Add Income' : 'Edit Income'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Income Source Autocomplete
            Autocomplete<String>(
              initialValue: TextEditingValue(text: _sourceController.text),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return IncomeCategories.incomeSources;
                }
                return IncomeCategories.incomeSources.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                setState(() {
                  _sourceController.text = selection;
                });
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Source *',
                    hintText: 'Select or type income source',
                    prefixIcon: const Icon(Icons.source),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: () {
                        focusNode.requestFocus();
                      },
                    ),
                  ),
                  validator: (value) => Validators.validateRequired(value, 'source'),
                  onChanged: (value) {
                    _sourceController.text = value;
                  },
                );
              },
              optionsViewBuilder: (
                BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options,
              ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      width: MediaQuery.of(context).size.width - 32,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return ListTile(
                            leading: Icon(
                              _getIconForSource(option),
                              color: AppColors.primaryBlue,
                              size: 20,
                            ),
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
              items: IncomeCategories.categoryNames.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(IncomeCategories.getIcon(category)),
                      const SizedBox(width: 8),
                      Text(IncomeCategories.getLabel(category)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _isHourlyIncome = value == 'hourly';
                });
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Hourly Income'),
              value: _isHourlyIncome,
              onChanged: (value) {
                setState(() {
                  _isHourlyIncome = value;
                  if (value) {
                    _selectedCategory = 'hourly';
                  }
                });
              },
            ),
            if (_isHourlyIncome) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _hourlyRateController,
                decoration: const InputDecoration(
                  labelText: 'Hourly Rate',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validateHourlyRate,
                onChanged: _calculateAmount,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hoursWorkedController,
                decoration: const InputDecoration(
                  labelText: 'Hours Worked',
                  prefixIcon: Icon(Icons.access_time),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validateHours,
                onChanged: _calculateAmount,
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.attach_money),
                enabled: !_isHourlyIncome,
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
              onPressed: _saveIncome,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.success,
              ),
              child: Text(widget.income == null ? 'Add Income' : 'Update Income'),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateAmount(String? value) {
    if (_isHourlyIncome) {
      final rate = double.tryParse(_hourlyRateController.text) ?? 0;
      final hours = double.tryParse(_hoursWorkedController.text) ?? 0;
      final amount = rate * hours;
      _amountController.text = amount.toStringAsFixed(2);
    }
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

  void _saveIncome() {
    if (_formKey.currentState!.validate()) {
      final income = Income(
        id: widget.income?.id ?? Helpers.generateId(),
        amount: double.parse(_amountController.text),
        source: _sourceController.text,
        category: _selectedCategory,
        date: _selectedDate,
        hourlyRate: _isHourlyIncome ? double.tryParse(_hourlyRateController.text) : null,
        hoursWorked: _isHourlyIncome ? double.tryParse(_hoursWorkedController.text) : null,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      );

      if (widget.income == null) {
        context.read<IncomeProvider>().addIncome(income);
      } else {
        context.read<IncomeProvider>().updateIncome(income);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.income == null ? 'Income added' : 'Income updated'),
        ),
      );
    }
  }

  IconData _getIconForSource(String source) {
    if (source.contains('Delivery') || source.contains('Ride')) return Icons.delivery_dining;
    if (source.contains('Freelance') || source.contains('Design') || source.contains('Web')) return Icons.laptop_mac;
    if (source.contains('Tutoring') || source.contains('Teaching')) return Icons.school;
    if (source.contains('Allowance') || source.contains('Family')) return Icons.family_restroom;
    if (source.contains('Scholarship')) return Icons.workspace_premium;
    if (source.contains('Content')) return Icons.video_library;
    if (source.contains('Campus') || source.contains('Job')) return Icons.work;
    if (source.contains('Research')) return Icons.science;
    if (source.contains('Online')) return Icons.language;
    return Icons.monetization_on;
  }
}
