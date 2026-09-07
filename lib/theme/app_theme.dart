import 'package:flutter/material.dart';

/// Brand colours — Atelier system (modern, elegant, sophisticated).
class AppColors {
  AppColors._();

  static const Color claret = Color(0xFF6B1826);
  static const Color champagne = Color(0xFFC5A572);
  static const Color ivory = Color(0xFFF5F0E8);
  static const Color ink = Color(0xFF1A1412);
  static const Color stone = Color(0xFFDED4C4);

  /// Legacy aliases used across screens.
  static const Color red = claret;
  static const Color yellow = champagne;
  static const Color black = ink;
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF6B635C);
  static const Color lightGrey = Color(0xFFF2EEE7);
  static const Color border = Color(0xFFE0D8CC);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.claret,
        primary: AppColors.claret,
        secondary: AppColors.champagne,
        surface: AppColors.ivory,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.ivory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.claret, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.claret,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.8,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.claret),
      ),
    );
    return base;
  }
}
