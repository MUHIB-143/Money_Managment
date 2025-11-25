import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:managment/services/database_service.dart';
import 'package:managment/services/settings_service.dart';
import 'package:managment/providers/income_provider.dart';
import 'package:managment/providers/expense_provider.dart';
import 'package:managment/providers/savings_provider.dart';
import 'package:managment/providers/tuition_provider.dart';
import 'package:managment/providers/settings_provider.dart';
import 'package:managment/theme/app_theme.dart';
import 'package:managment/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await DatabaseService().init();
  await SettingsService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IncomeProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => SavingsProvider()),
        ChangeNotifierProvider(create: (_) => TuitionProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: 'Student Money Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.themeModeEnum,
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}
