import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary gradient
  static const purple1 = Color(0xFF2D1B69);
  static const purple2 = Color(0xFF6C3483);
  static const purple3 = Color(0xFF9B59B6);
  static const roseGold = Color(0xFFE8A0BF);
  static const gold = Color(0xFFD4A843);

  // Dark mode
  static const darkBg = Color(0xFF080714);
  static const darkSurface = Color(0xFF12102B);
  static const darkCard = Color(0xFF1C1A3A);
  static const darkBorder = Color(0xFF2E2B50);

  // Light mode (warm paper)
  static const lightBg = Color(0xFFFAF6EF);
  static const lightSurface = Color(0xFFFFFDF8);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFEDE4D3);

  // Sepia mode
  static const sepiaBg = Color(0xFFF5EDD8);
  static const sepiaSurface = Color(0xFFFDF6E3);
  static const sepiaCard = Color(0xFFF8F0D8);
  static const sepiaText = Color(0xFF5C4A1E);

  // Accents
  static const accent1 = Color(0xFF9B59B6);
  static const accent2 = Color(0xFFE8A0BF);
  static const accent3 = Color(0xFFD4A843);
  static const successGreen = Color(0xFF27AE60);
}

enum ReadingTheme { dark, light, sepia }

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent1,
          secondary: AppColors.roseGold,
          surface: AppColors.darkSurface,
        ),
        useMaterial3: true,
        textTheme: _buildTextTheme(Brightness.dark),
      );

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.accent1,
          secondary: AppColors.roseGold,
          surface: AppColors.lightSurface,
        ),
        useMaterial3: true,
        textTheme: _buildTextTheme(Brightness.light),
      );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseColor =
        brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1035);
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
          color: baseColor, fontWeight: FontWeight.bold),
      displayMedium:
          GoogleFonts.playfairDisplay(color: baseColor, fontSize: 28),
      titleLarge: GoogleFonts.playfairDisplay(
          color: baseColor, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.notoSerif(color: baseColor, fontSize: 18),
      bodyMedium: GoogleFonts.lato(color: baseColor),
      labelLarge:
          GoogleFonts.lato(color: baseColor, fontWeight: FontWeight.w600),
    );
  }

  static LinearGradient get heroGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.purple1, AppColors.purple2, AppColors.darkBg],
        stops: [0.0, 0.5, 1.0],
      );

  static LinearGradient get cardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.purple3, AppColors.roseGold],
      );
}

// Reading theme helper
extension ReadingThemeHelper on ReadingTheme {
  Color get bgColor {
    switch (this) {
      case ReadingTheme.dark:
        return AppColors.darkBg;
      case ReadingTheme.light:
        return AppColors.lightBg;
      case ReadingTheme.sepia:
        return AppColors.sepiaBg;
    }
  }

  Color get surfaceColor {
    switch (this) {
      case ReadingTheme.dark:
        return AppColors.darkSurface;
      case ReadingTheme.light:
        return AppColors.lightSurface;
      case ReadingTheme.sepia:
        return AppColors.sepiaSurface;
    }
  }

  Color get textColor {
    switch (this) {
      case ReadingTheme.dark:
        return const Color(0xFFE8E0F0);
      case ReadingTheme.light:
        return const Color(0xFF1A1035);
      case ReadingTheme.sepia:
        return AppColors.sepiaText;
    }
  }

  Color get subTextColor {
    switch (this) {
      case ReadingTheme.dark:
        return Colors.white54;
      case ReadingTheme.light:
        return Colors.black45;
      case ReadingTheme.sepia:
        return const Color(0xFF8B7355);
    }
  }

  Color get dialogueColor {
    switch (this) {
      case ReadingTheme.dark:
        return const Color(0xFFCE93D8);
      case ReadingTheme.light:
        return const Color(0xFF6C3483);
      case ReadingTheme.sepia:
        return const Color(0xFF8B4513);
    }
  }

  Color get cardColor {
    switch (this) {
      case ReadingTheme.dark:
        return AppColors.darkCard;
      case ReadingTheme.light:
        return AppColors.lightCard;
      case ReadingTheme.sepia:
        return AppColors.sepiaCard;
    }
  }

  bool get isDark => this == ReadingTheme.dark;

  String get displayName {
    switch (this) {
      case ReadingTheme.dark:
        return 'Tungi';
      case ReadingTheme.light:
        return 'Kunduzi';
      case ReadingTheme.sepia:
        return 'Sepia';
    }
  }

  IconData get icon {
    switch (this) {
      case ReadingTheme.dark:
        return Icons.nightlight_round;
      case ReadingTheme.light:
        return Icons.wb_sunny_outlined;
      case ReadingTheme.sepia:
        return Icons.book_outlined;
    }
  }
}
