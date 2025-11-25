import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:managment/providers/income_provider.dart';
import 'package:managment/providers/expense_provider.dart';
import 'package:managment/providers/settings_provider.dart';
import 'package:managment/theme/app_colors.dart';
import 'package:managment/widgets/glassmorphism.dart';
import 'package:managment/utils/helpers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:managment/screens/income_screen.dart';
import 'package:managment/screens/expense_screen.dart';
import 'package:managment/screens/savings_screen.dart';
import 'package:managment/screens/tuition_screen.dart';
import 'package:managment/screens/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _DashboardHome(),
    const IncomeScreen(),
    const ExpenseScreen(),
    const SavingsScreen(),
    const TuitionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _selectedIndex == 0 ? _buildFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Income',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.savings),
          label: 'Savings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Tuition',
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showAddTransactionDialog();
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Transaction'),
    );
  }

  void _showAddTransactionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Transaction',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IncomeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Income'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExpenseScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text('Expense'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.surfaceDark
                : AppColors.primaryBlueLight.withOpacity(0.1),
          ],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildBalanceCard(),
                const SizedBox(height: 16),
                _buildQuickStats(),
                const SizedBox(height: 16),
                _buildExpenseChart(),
                const SizedBox(height: 16),
                _buildRecentTransactions(),
                const SizedBox(height: 100), // Space for FAB
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: Builder(
        builder: (context) {
          return FlexibleSpaceBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Helpers.getGreeting(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                      Text(
                        'Student',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Consumer2<IncomeProvider, ExpenseProvider>(
      builder: (context, incomeProvider, expenseProvider, _) {
        final totalIncome = incomeProvider.totalIncome;
        final totalExpenses = expenseProvider.totalExpenses;
        final balance = totalIncome - totalExpenses;
        final currencySymbol = context.watch<SettingsProvider>().currencySymbol;

        return GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.primaryBlue,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Current Balance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                Helpers.formatCurrency(balance, currencySymbol),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: balance >= 0 ? AppColors.success : AppColors.error,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceDetail(
                      'Income',
                      Helpers.formatCurrency(totalIncome, currencySymbol),
                      Icons.arrow_downward,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBalanceDetail(
                      'Expenses',
                      Helpers.formatCurrency(totalExpenses, currencySymbol),
                      Icons.arrow_upward,
                      AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceDetail(
      String label, String amount, IconData icon, Color color) {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickStats() {
    return Consumer2<IncomeProvider, ExpenseProvider>(
      builder: (context, incomeProvider, expenseProvider, _) {
        final monthIncome = incomeProvider.monthIncome;
        final monthExpenses = expenseProvider.monthExpenses;
        final currencySymbol = context.watch<SettingsProvider>().currencySymbol;

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'This Month',
                Helpers.formatCurrency(monthIncome, currencySymbol),
                'Income',
                Icons.trending_up,
                AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'This Month',
                Helpers.formatCurrency(monthExpenses, currencySymbol),
                'Spent',
                Icons.shopping_cart,
                AppColors.accentYellow,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String amount, String subtitle, IconData icon, Color color) {
    return Builder(
      builder: (context) {
        return GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpenseChart() {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, _) {
        final categoryData = expenseProvider.getMonthExpensesByCategory();

        if (categoryData.isEmpty) {
          return GlassCard(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.pie_chart_outline,
                    size: 64,
                    color: AppColors.textSecondaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No expenses this month',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Spending by Category',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: _getPieChartSections(categoryData),
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    pieTouchData: PieTouchData(enabled: true),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLegend(categoryData),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _getPieChartSections(Map<String, double> data) {
    final total = data.values.fold(0.0, (sum, value) => sum + value);
    
    return data.entries.map((entry) {
      final percentage = (entry.value / total * 100);
      final color = AppColors.getExpenseCategoryColor(entry.key);
      
      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        color: color,
        radius: 75,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> data) {
    return Builder(
      builder: (context) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: data.entries.map((entry) {
            final color = AppColors.getExpenseCategoryColor(entry.key);
            return Chip(
              avatar: CircleAvatar(
                backgroundColor: color,
                radius: 8,
              ),
              label: Text(
                entry.key.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              backgroundColor: color.withValues(alpha: 0.1),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRecentTransactions() {
    return Builder(
      builder: (context) {
        return GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: View all
                    },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer2<IncomeProvider, ExpenseProvider>(
            builder: (context, incomeProvider, expenseProvider, _) {
              final hasTransactions = incomeProvider.incomes.isNotEmpty ||
                  expenseProvider.expenses.isNotEmpty;

              if (!hasTransactions) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No transactions yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                  ),
                );
              }

              // Get recent 5 transactions (combined income and expenses)
              final recentIncomes = incomeProvider.incomes.take(3).toList();
              final recentExpenses = expenseProvider.expenses.take(3).toList();

              return Column(
                children: [
                  ...recentExpenses.map((expense) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.error.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.arrow_upward,
                            color: AppColors.error,
                          ),
                        ),
                        title: Text(expense.category),
                        subtitle: Text(
                          Helpers.formatDate(
                            expense.date,
                            context.watch<SettingsProvider>().dateFormat,
                          ),
                        ),
                        trailing: Text(
                          '-${Helpers.formatCurrency(expense.amount, context.watch<SettingsProvider>().currencySymbol)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      )),
                  ...recentIncomes.map((income) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.success.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.arrow_downward,
                            color: AppColors.success,
                          ),
                        ),
                        title: Text(income.source),
                        subtitle: Text(
                          Helpers.formatDate(
                            income.date,
                            context.watch<SettingsProvider>().dateFormat,
                          ),
                        ),
                        trailing: Text(
                          '+${Helpers.formatCurrency(income.amount, context.watch<SettingsProvider>().currencySymbol)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      )),
                ],
              );
            },
          ),
        ],
      ),
        );
      },
    );
  }
}
