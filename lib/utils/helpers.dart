import 'package:intl/intl.dart';

class Helpers {
  // Format currency
  static String formatCurrency(double amount, String currencySymbol) {
    return '$currencySymbol${amount.toStringAsFixed(2)}';
  }

  // Format currency with compact notation for large numbers
  static String formatCurrencyCompact(double amount, String currencySymbol) {
    if (amount >= 1000000) {
      return '$currencySymbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$currencySymbol${(amount / 1000).toStringAsFixed(1)}K';
    }
    return formatCurrency(amount, currencySymbol);
  }

  // Format date
  static String formatDate(DateTime date, String format) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return DateFormat('MM/dd/yyyy').format(date);
    }
  }

  // Format time
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // Format date and time
  static String formatDateTime(DateTime dateTime, String dateFormat) {
    return '${formatDate(dateTime, dateFormat)} ${formatTime(dateTime)}';
  }

  // Get relative time (e.g., "2 days ago", "in 3 days")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      // Past
      final absDifference = difference.abs();
      if (absDifference.inDays > 30) {
        final months = (absDifference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (absDifference.inDays > 0) {
        return '${absDifference.inDays} ${absDifference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (absDifference.inHours > 0) {
        return '${absDifference.inHours} ${absDifference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (absDifference.inMinutes > 0) {
        return '${absDifference.inMinutes} ${absDifference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } else {
      // Future
      if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'in $months ${months == 1 ? 'month' : 'months'}';
      } else if (difference.inDays > 0) {
        return 'in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        return 'Now';
      }
    }
  }

  // Get month start and end
  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getMonthEnd(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }

  // Get week start and end (week starts on Monday)
  static DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static DateTime getWeekEnd(DateTime date) {
    return getWeekStart(date).add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  // Get day start and end
  static DateTime getDayStart(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getDayEnd(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  // Generate unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Calculate percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total * 100).clamp(0, 100);
  }

  // Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Capitalize first letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Get greeting based on time of day
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Get last N months
  static List<DateTime> getLastNMonths(int n) {
    final now = DateTime.now();
    return List.generate(n, (index) {
      return DateTime(now.year, now.month - index, 1);
    }).reversed.toList();
  }

  // Calculate average
  static double calculateAverage(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}
