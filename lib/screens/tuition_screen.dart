import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:managment/models/tuition_fee_model.dart';
import 'package:managment/providers/tuition_provider.dart';
import 'package:managment/providers/settings_provider.dart';
import 'package:managment/theme/app_colors.dart';
import 'package:managment/utils/helpers.dart';
import 'package:managment/utils/validators.dart';
import 'package:managment/widgets/glassmorphism.dart';

class TuitionScreen extends StatelessWidget {
  const TuitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuition Fees'),
      ),
      body: Consumer<TuitionProvider>(
        builder: (context, provider, _) {
          if (provider.tuitionFees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: AppColors.textSecondaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tuition fees recorded',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add tuition information',
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
              ...provider.tuitionFees.map((tuition) => _buildTuitionCard(context, tuition)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTuitionDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Tuition'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildSummaryCard(TuitionProvider provider, BuildContext context) {
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Due',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            Helpers.formatCurrency(provider.totalDue, currencySymbol),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: provider.totalDue > 0 ? AppColors.warning : AppColors.success,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${provider.unpaidFees.length} unpaid fees',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildTuitionCard(BuildContext context, TuitionFee tuition) {
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
    final dateFormat = context.watch<SettingsProvider>().dateFormat;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => _showTuitionDetails(context, tuition),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tuition.semester,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (tuition.institution != null)
                          Text(
                            tuition.institution!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  if (tuition.isFullyPaid)
                    const Icon(Icons.check_circle, color: AppColors.success),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: tuition.progressPercentage / 100,
                  minHeight: 8,
                  backgroundColor: AppColors.lightGray,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    tuition.isFullyPaid ? AppColors.success : AppColors.primaryBlue,
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
                      Text('Paid', style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        Helpers.formatCurrency(tuition.totalPaid, currencySymbol),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Remaining', style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        Helpers.formatCurrency(tuition.remainingBalance, currencySymbol),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: tuition.isFullyPaid ? AppColors.success : AppColors.error,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    '${tuition.progressPercentage.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: tuition.isFullyPaid ? AppColors.success : AppColors.primaryBlue,
                        ),
                  ),
                ],
              ),
              if (tuition.dueDate != null && !tuition.isFullyPaid) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: tuition.isOverdue ? AppColors.error : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${Helpers.formatDate(tuition.dueDate!, dateFormat)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: tuition.isOverdue ? AppColors.error : null,
                          ),
                    ),
                    if (tuition.daysUntilDue != null)
                      Text(
                        ' (${tuition.daysUntilDue! > 0 ? tuition.daysUntilDue : 'Overdue'}${tuition.daysUntilDue! > 0 ? ' days' : ''})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: tuition.isOverdue ? AppColors.error : AppColors.info,
                            ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTuitionDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditTuitionScreen(),
      ),
    );
  }

  void _showTuitionDetails(BuildContext context, TuitionFee tuition) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TuitionDetailsScreen(tuition: tuition),
      ),
    );
  }
}

class AddEditTuitionScreen extends StatefulWidget {
  final TuitionFee? tuition;

  const AddEditTuitionScreen({super.key, this.tuition});

  @override
  State<AddEditTuitionScreen> createState() => _AddEditTuitionScreenState();
}

class _AddEditTuitionScreenState extends State<AddEditTuitionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _totalAmountController = TextEditingController();
  final _semesterController = TextEditingController();
  final _institutionController = TextEditingController();

  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.tuition != null) {
      _totalAmountController.text = widget.tuition!.totalAmount.toString();
      _semesterController.text = widget.tuition!.semester;
      _institutionController.text = widget.tuition!.institution ?? '';
      _dueDate = widget.tuition!.dueDate;
    }
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _semesterController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tuition == null ? 'Add Tuition' : 'Edit Tuition'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _semesterController,
              decoration: const InputDecoration(
                labelText: 'Semester',
                hintText: 'e.g., Fall 2024, Spring 2025',
                prefixIcon: Icon(Icons.event),
              ),
              validator: (value) => Validators.validateRequired(value, 'semester'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _institutionController,
              decoration: const InputDecoration(
                labelText: 'Institution (Optional)',
                hintText: 'e.g., University Name',
                prefixIcon: Icon(Icons.school),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _totalAmountController,
              decoration: const InputDecoration(
                labelText: 'Total Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: Validators.validateAmount,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Due Date (Optional)'),
              subtitle: Text(
                _dueDate != null
                    ? Helpers.formatDate(_dueDate!, context.watch<SettingsProvider>().dateFormat)
                    : 'No due date set',
              ),
              leading: const Icon(Icons.calendar_today),
              trailing: _dueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _dueDate = null;
                        });
                      },
                    )
                  : null,
              onTap: _pickDueDate,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveTuition,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: Text(widget.tuition == null ? 'Add Tuition' : 'Update Tuition'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  void _saveTuition() {
    if (_formKey.currentState!.validate()) {
      final tuition = TuitionFee(
        id: widget.tuition?.id ?? Helpers.generateId(),
        totalAmount: double.parse(_totalAmountController.text),
        semester: _semesterController.text,
        institution: _institutionController.text.isEmpty ? null : _institutionController.text,
        dueDate: _dueDate,
        createdDate: widget.tuition?.createdDate ?? DateTime.now(),
        payments: widget.tuition?.payments ?? [],
      );

      if (widget.tuition == null) {
        context.read<TuitionProvider>().addTuitionFee(tuition);
      } else {
        context.read<TuitionProvider>().updateTuitionFee(tuition);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.tuition == null ? 'Tuition added' : 'Tuition updated'),
        ),
      );
    }
  }
}

class TuitionDetailsScreen extends StatelessWidget {
  final TuitionFee tuition;

  const TuitionDetailsScreen({super.key, required this.tuition});

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
    final dateFormat = context.watch<SettingsProvider>().dateFormat;

    return Scaffold(
      appBar: AppBar(
        title: Text(tuition.semester),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTuitionScreen(tuition: tuition),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Fee', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  Helpers.formatCurrency(tuition.totalAmount, currencySymbol),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Paid', style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            Helpers.formatCurrency(tuition.totalPaid, currencySymbol),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Remaining', style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            Helpers.formatCurrency(tuition.remainingBalance, currencySymbol),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: tuition.isFullyPaid ? AppColors.success : AppColors.error,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton.icon(
                onPressed: () => _showAddPaymentDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Payment'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (tuition.payments.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No payments recorded',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                ),
              ),
            )
          else
            ...tuition.payments.map((payment) {
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.success,
                    child: Icon(Icons.payment, color: Colors.white),
                  ),
                  title: Text(Helpers.formatCurrency(payment.amount, currencySymbol)),
                  subtitle: Text(Helpers.formatDate(payment.date, dateFormat)),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty) {
                final payment = TuitionPayment(
                  amount: double.parse(amountController.text),
                  date: selectedDate,
                );
                tuition.addPayment(payment);
                context.read<TuitionProvider>().updateTuitionFee(tuition);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment added')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
