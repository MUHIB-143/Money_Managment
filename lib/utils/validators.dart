class Validators {
  // Validate amount (must be positive)
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    return null;
  }

  // Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  // Validate date
  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date';
    }
    return null;
  }

  // Validate future date
  static String? validateFutureDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date';
    }

    if (date.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }

    return null;
  }

  // Validate target amount for savings goal
  static String? validateTargetAmount(String? currentAmountStr, String? targetAmountStr) {
    final currentAmount = double.tryParse(currentAmountStr ?? '0') ?? 0;
    final targetAmount = double.tryParse(targetAmountStr ?? '0') ?? 0;

    if (targetAmount <= 0) {
      return 'Target amount must be greater than 0';
    }

    if (currentAmount >= targetAmount) {
      return 'Target must be greater than current amount';
    }

    return null;
  }

  // Validate hourly rate
  static String? validateHourlyRate(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final rate = double.tryParse(value);
    if (rate == null) {
      return 'Please enter a valid hourly rate';
    }

    if (rate <= 0) {
      return 'Hourly rate must be greater than 0';
    }

    return null;
  }

  // Validate hours worked
  static String? validateHours(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final hours = double.tryParse(value);
    if (hours == null) {
      return 'Please enter valid hours';
    }

    if (hours <= 0) {
      return 'Hours must be greater than 0';
    }

    if (hours > 24) {
      return 'Hours cannot exceed 24 per day';
    }

    return null;
  }

  // Validate text length
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters';
    }
    return null;
  }

  // Validate budget allocation
  static String? validateBudgetAllocation(String? value, String period) {
    final amount = double.tryParse(value ?? '0') ?? 0;
    
    if (amount <= 0) {
      return 'Budget amount must be greater than 0';
    }

    // Add sensible limits based on period
    if (period == 'daily' && amount > 10000) {
      return 'Daily budget seems too high';
    } else if (period == 'weekly' && amount > 50000) {
      return 'Weekly budget seems too high';
    } else if (period == 'monthly' && amount > 200000) {
      return 'Monthly budget seems too high';
    }

    return null;
  }
}
