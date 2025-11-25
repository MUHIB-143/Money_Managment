import 'package:flutter/material.dart';
import 'package:managment/services/settings_service.dart';

class SettingsProvider with ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  String _currency = 'USD';
  String _currencySymbol = '\$';
  String _dateFormat = 'MM/dd/yyyy';
  String _themeMode = 'system';
  double _fontSize = 16.0;

  String get currency => _currency;
  String get currencySymbol => _currencySymbol;
  String get dateFormat => _dateFormat;
  String get themeMode => _themeMode;
  double get fontSize => _fontSize;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    _currency = _settingsService.currency;
    _currencySymbol = _settingsService.currencySymbol;
    _dateFormat = _settingsService.dateFormat;
    _themeMode = _settingsService.themeMode;
    _fontSize = _settingsService.fontSize;
    notifyListeners();
  }

  Future<void> setCurrency(String currencyCode, String symbol) async {
    _currency = currencyCode;
    _currencySymbol = symbol;
    await _settingsService.setCurrency(currencyCode);
    await _settingsService.setCurrencySymbol(symbol);
    notifyListeners();
  }

  Future<void> setDateFormat(String format) async {
    _dateFormat = format;
    await _settingsService.setDateFormat(format);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _settingsService.setThemeMode(mode);
    notifyListeners();
  }

  ThemeMode get themeModeEnum {
    switch (_themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    await _settingsService.setFontSize(size);
    notifyListeners();
  }

  Future<void> resetSettings() async {
    await _settingsService.resetToDefaults();
    await loadSettings();
  }
}
