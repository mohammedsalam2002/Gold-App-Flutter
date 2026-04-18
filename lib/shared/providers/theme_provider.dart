// lib/shared/providers/theme_provider.dart
// إدارة حالة الثيم (فاتح/داكن)
 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
import '../../core/constants/app_constants.dart';
 
// Provider لإدارة وضع الثيم
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
 
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadTheme(); // تحميل الثيم المحفوظ عند بدء التطبيق
  }
 
  // تحميل الثيم من SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(AppConstants.prefKeyThemeMode) ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
 
  // تبديل الثيم وحفظه
  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefKeyThemeMode, !isDark);
  }
 
  bool get isDark => state == ThemeMode.dark;
}