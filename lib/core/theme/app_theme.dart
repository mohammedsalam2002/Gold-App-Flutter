// lib/core/theme/app_theme.dart
// تعريف الثيم الفاتح والداكن للتطبيق
 
import 'package:flutter/material.dart';
 
class AppTheme {
  AppTheme._();
 
  // ============================
  // الألوان الأساسية
  // ============================
  static const Color goldColor = Color(0xFFD4AF37);       // ذهبي
  static const Color goldDark = Color(0xFFB8960C);         // ذهبي داكن
  static const Color goldLight = Color(0xFFF5D87A);        // ذهبي فاتح
  static const Color primaryColor = Color(0xFF1A1A2E);     // كحلي داكن
  static const Color accentColor = Color(0xFF16213E);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color dollarGreen = Color(0xFF27AE60);
 
  // ============================
  // الثيم الفاتح
  // ============================
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: goldColor,
          brightness: Brightness.light,
          primary: primaryColor,
          secondary: goldColor,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F6F0),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4.1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: goldColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: goldColor, width: 2),
          ),
          labelStyle: const TextStyle(fontFamily: 'Cairo'),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontFamily: 'Cairo'),
          bodyLarge: TextStyle(fontFamily: 'Cairo'),
          bodyMedium: TextStyle(fontFamily: 'Cairo'),
        ),
      );
 
  // ============================
  // الثيم الداكن
  // ============================
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: goldColor,
          brightness: Brightness.dark,
          primary: goldColor,
          secondary: goldLight,
          surface: const Color(0xFF1E1E2E),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A2E),
          foregroundColor: goldColor,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: goldColor,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFF1E1E2E),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: goldColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: goldColor, width: 2),
          ),
          labelStyle: const TextStyle(fontFamily: 'Cairo', color: Colors.white70),
          fillColor: const Color(0xFF1E1E2E),
          filled: true,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontFamily: 'Cairo'),
          bodyLarge: TextStyle(fontFamily: 'Cairo'),
          bodyMedium: TextStyle(fontFamily: 'Cairo'),
        ),
      );
}