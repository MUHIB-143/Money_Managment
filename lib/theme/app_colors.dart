import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Light Blue Theme)
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryBlueDark = Color(0xFF357ABD);
  static const Color primaryBlueLight = Color(0xFF6BA3E8);

  // Accent Colors
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color accentYellowDark = Color(0xFFFFA000);

  // Neon Teal (from previous design - can be used as secondary accent)
  static const Color neonTeal = Color(0xFF00D9FF);
  static const Color neonTealDark = Color(0xFF00A8CC);

  // Gold (from previous design - can be used for premium features)
  static const Color gold = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFB8860B);

  // Neutrals
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF757575);
  static const Color darkCharcoal = Color(0xFF333333);
  static const Color almostBlack = Color(0xFF1A1A1A);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF2196F3);

  // Background Colors - Light Theme
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;

  // Background Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textDisabledDark = Color(0xFF757575);

  // Category Colors for Expenses
  static const Map<String, Color> expenseCategories = {
    'food': Color(0xFFFF6B6B),
    'transport': Color(0xFF4ECDC4),
    'entertainment': Color(0xFFFFBE0B),
    'education': Color(0xFF95E1D3),
    'bills': Color(0xFFFF8C42),
    'health': Color(0xFFEE6C4D),
    'shopping': Color(0xFFC77DFF),
    'other': Color(0xFF9C9C9C),
  };

  // Category Colors for Income
  static const Map<String, Color> incomeCategories = {
    'hourly': Color(0xFF06D6A0),
    'freelance': Color(0xFF118AB2),
    'scholarship': Color(0xFF073B4C),
    'allowance': Color(0xFF7209B7),
    'other': Color(0xFF4CC9F0),
  };

  // Gradient Colors for Premium Feel
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentYellow, accentYellowDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [neonTeal, neonTealDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism Colors
  static Color glassLight = Colors.white.withOpacity(0.1);
  static Color glassDark = Colors.black.withOpacity(0.2);
  static Color glassBlur = Colors.white.withOpacity(0.05);

  // Get category color
  static Color getExpenseCategoryColor(String category) {
    return expenseCategories[category] ?? expenseCategories['other']!;
  }

  static Color getIncomeCategoryColor(String category) {
    return incomeCategories[category] ?? incomeCategories['other']!;
  }
}
