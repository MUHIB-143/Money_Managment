import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:managment/utils/constants.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== CURRENCY ==========

  String get currency {
    return _prefs.getString(SettingsKeys.currency) ?? Defaults.currency;
  }

  Future<void> setCurrency(String currencyCode) async {
    await _prefs.setString(SettingsKeys.currency, currencyCode);
    // Also update the symbol
    final symbol = Currencies.getSymbol(currencyCode);
    await setCurrencySymbol(symbol);
  }

  String get currencySymbol {
    return _prefs.getString(SettingsKeys.currencySymbol) ?? Defaults.currencySymbol;
  }

  Future<void> setCurrencySymbol(String symbol) async {
    await _prefs.setString(SettingsKeys.currencySymbol, symbol);
  }

  // ========== LANGUAGE ==========

  String get language {
    return _prefs.getString(SettingsKeys.language) ?? 'en';
  }

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(SettingsKeys.language, languageCode);
  }

  // ========== DATE FORMAT ==========

  String get dateFormat {
    return _prefs.getString(SettingsKeys.dateFormat) ?? Defaults.dateFormat;
  }

  Future<void> setDateFormat(String format) async {
    await _prefs.setString(SettingsKeys.dateFormat, format);
  }

  // ========== THEME ==========

  String get themeMode {
    return _prefs.getString(SettingsKeys.themeMode) ?? Defaults.themeMode;
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(SettingsKeys.themeMode, mode);
  }

  ThemeMode getThemeModeEnum() {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // ========== FONT SIZE ==========

  double get fontSize {
    return _prefs.getDouble(SettingsKeys.fontSize) ?? Defaults.defaultFontSize;
  }

  Future<void> setFontSize(double size) async {
    await _prefs.setDouble(SettingsKeys.fontSize, size);
  }

  // ========== ONBOARDING ==========

  bool get hasCompletedOnboarding {
    return _prefs.getBool(SettingsKeys.hasCompletedOnboarding) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(SettingsKeys.hasCompletedOnboarding, completed);
  }

  // ========== RESET ==========

  Future<void> resetToDefaults() async {
    await _prefs.clear();
  }

  // ========== EXPORT SETTINGS ==========

  Map<String, dynamic> exportSettings() {
    return {
      'currency': currency,
      'currencySymbol': currencySymbol,
      'language': language,
      'dateFormat': dateFormat,
      'themeMode': themeMode,
      'fontSize': fontSize,
    };
  }

  Future<void> importSettings(Map<String, dynamic> settings) async {
    if (settings['currency'] != null) {
      await setCurrency(settings['currency']);
    }
    if (settings['language'] != null) {
      await setLanguage(settings['language']);
    }
    if (settings['dateFormat'] != null) {
      await setDateFormat(settings['dateFormat']);
    }
    if (settings['themeMode'] != null) {
      await setThemeMode(settings['themeMode']);
    }
    if (settings['fontSize'] != null) {
      await setFontSize(settings['fontSize']);
    }
  }
}
