import 'package:flutter/material.dart';

// App Information
class AppInfo {
  static const String appName = 'StudentMoneyManager';
  static const String appVersion = '1.0.0';
}

// Expense Categories with icons
class ExpenseCategories {
  static const Map<String, IconData> categories = {
    'food': Icons.restaurant,
    'transport': Icons.directions_car,
    'entertainment': Icons.movie,
    'education': Icons.school,
    'bills': Icons.receipt_long,
    'health': Icons.local_hospital,
    'shopping': Icons.shopping_bag,
    'other': Icons.category,
  };

  static const List<String> categoryNames = [
    'food',
    'transport',
    'entertainment',
    'education',
    'bills',
    'health',
    'shopping',
    'other',
  ];

  static const Map<String, String> categoryLabels = {
    'food': 'Food & Dining',
    'transport': 'Transportation',
    'entertainment': 'Entertainment',
    'education': 'Education',
    'bills': 'Bills & Utilities',
    'health': 'Health & Fitness',
    'shopping': 'Shopping',
    'other': 'Other',
  };

  static IconData getIcon(String category) {
    return categories[category] ?? Icons.category;
  }

  static String getLabel(String category) {
    return categoryLabels[category] ?? category;
  }
}

// Income Categories
class IncomeCategories {
  static const Map<String, IconData> categories = {
    'hourly': Icons.access_time,
    'freelance': Icons.work,
    'scholarship': Icons.school,
    'allowance': Icons.account_balance_wallet,
    'other': Icons.attach_money,
  };

  static const List<String> incomeCategories = [
    'Salary',
    'Part-time',
    'Freelance',
    'Scholarship',
    'Allowance',
    'Investment',
    'Other',
  ];

  // Predefined income sources for quick selection
  static const List<String> incomeSources = [
    'Part-time Job',
    'Freelance Work',
    'Food Delivery',
    'Ride Sharing',
    'Tutoring',
    'Internship',
    'Scholarship Grant',
    'Family Allowance',
    'Online Work',
    'Content Creation',
    'Graphic Design',
    'Web Development',
    'Data Entry',
    'Virtual Assistant',
    'Teaching',
    'Research Assistant',
    'Campus Job',
    'Retail Work',
    'Customer Service',
    'Other',
  ];

  static const List<String> categoryNames = [
    'hourly',
    'freelance',
    'scholarship',
    'allowance',
    'other',
  ];

  static const Map<String, String> categoryLabels = {
    'hourly': 'Hourly Work',
    'freelance': 'Freelance',
    'scholarship': 'Scholarship',
    'allowance': 'Allowance',
    'other': 'Other Income',
  };

  static IconData getIcon(String category) {
    return categories[category] ?? Icons.attach_money;
  }

  static String getLabel(String category) {
    return categoryLabels[category] ?? category;
  }
}

// Budget Periods
class BudgetPeriods {
  static const List<String> periods = ['daily', 'weekly', 'monthly'];
  
  static const Map<String, String> periodLabels = {
    'daily': 'Daily',
    'weekly': 'Weekly',
    'monthly': 'Monthly',
  };

  static String getLabel(String period) {
    return periodLabels[period] ?? period;
  }
}

// Reminder Types
class ReminderTypes {
  static const String payment = 'payment';
  static const String tuition = 'tuition';
  static const String savings = 'savings';
  static const String custom = 'custom';

  static const List<String> types = [payment, tuition, savings, custom];

  static const Map<String, String> typeLabels = {
    payment: 'Payment Reminder',
    tuition: 'Tuition Reminder',
    savings: 'Savings Goal',
    custom: 'Custom Reminder',
  };

  static String getLabel(String type) {
    return typeLabels[type] ?? type;
  }
}

// Repeat Frequencies
class RepeatFrequencies {
  static const String daily = 'daily';
  static const String weekly = 'weekly';
  static const String monthly = 'monthly';

  static const List<String> frequencies = [daily, weekly, monthly];

  static const Map<String, String> frequencyLabels = {
    daily: 'Daily',
    weekly: 'Weekly',
    monthly: 'Monthly',
  };

  static String getLabel(String frequency) {
    return frequencyLabels[frequency] ?? frequency;
  }
}

// Common Currencies
class Currencies {
  static const List<Map<String, String>> currencies = [
    {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
    {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
    {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
    {'code': 'BDT', 'symbol': '৳', 'name': 'Bangladeshi Taka'},
    {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
    {'code': 'CAD', 'symbol': 'C\$', 'name': 'Canadian Dollar'},
    {'code': 'AUD', 'symbol': 'A\$', 'name': 'Australian Dollar'},
    {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
    {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan'},
  ];

  static String getSymbol(String code) {
    final currency = currencies.firstWhere(
      (c) => c['code'] == code,
      orElse: () => {'symbol': '\$'},
    );
    return currency['symbol']!;
  }
}

// Date Formats
class DateFormats {
  static const List<String> formats = [
    'MM/dd/yyyy',
    'dd/MM/yyyy',
    'yyyy-MM-dd',
    'dd-MM-yyyy',
  ];
}

// Hive Box Names
class HiveBoxes {
  static const String incomeBox = 'incomes';
  static const String expenseBox = 'expenses';
  static const String savingsGoalBox = 'savingsGoals';
  static const String tuitionFeeBox = 'tuitionFees';
  static const String budgetBox = 'budgets';
  static const String reminderBox = 'reminders';
  static const String settingsBox = 'settings';
}

// Settings Keys
class SettingsKeys {
  static const String currency = 'currency';
  static const String currencySymbol = 'currencySymbol';
  static const String language = 'language';
  static const String dateFormat = 'dateFormat';
  static const String themeMode = 'themeMode';
  static const String fontSize = 'fontSize';
  static const String hasCompletedOnboarding = 'hasCompletedOnboarding';
}

// Default Values
class Defaults {
  static const String currency = 'USD';
  static const String currencySymbol = '\$';
  static const String dateFormat = 'MM/dd/yyyy';
  static const String themeMode = 'system'; // light, dark, system
  static const double defaultFontSize = 16.0;
}

/// Developer information
class DeveloperInfo {
  static const String name = 'MARUFUL HAQUE MUHIB';
  static const String github = 'github.com/MUHIB-143';
  static const String githubUrl = 'https://github.com/MUHIB-143';
  static const String facebook = 'facebook.com/its.muhib.7';
  static const String facebookUrl = 'https://facebook.com/its.muhib.7';
  static const String role = 'Full Stack Developer';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
}
