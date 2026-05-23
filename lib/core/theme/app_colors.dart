import 'package:flutter/material.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────
class AppColors {
  // Deep cosmic palette
  static const cosmicBlack = Color(0xFF0A0015);
  static const darkViolet = Color(0xFF12002E);
  static const richPurpleBlack = Color(0xFF1A0533);
  static const deepPurple = Color(0xFF2D1B69);

  // Accent colors
  static const accentPurple = Color(0xFF9B59B6);
  static const accentViolet = Color(0xFF7C3AED);
  static const accentRose = Color(0xFFEC4899);
  static const accentGold = Color(0xFFF59E0B);
  static const accentBlush = Color(0xFFE8A0BF);
  static const accentBlue = Color(0xFF3B82F6);

  // Light palette
  static const etherealLavender = Color(0xFFF8F0FF);
  static const blushWhite = Color(0xFFFFF5F8);
  static const iceLavender = Color(0xFFF0F4FF);
  static const softPurple = Color(0xFF9B59B6);
  static const midPurple = Color(0xFF6C3483);
  static const lightLavender = Color(0xFFCE93D8);

  // Dark mode surfaces
  static const darkBg = Color(0xFF0D0A1A);
  static const darkSurface = Color(0xFF13102A);
  static const darkCard = Color(0xFF1A1535);

  // Light mode surfaces
  static const lightBg = Color(0xFFF8F0FF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightParchment = Color(0xFFFDF9FF);
  static const lightBorder = Color(0xFFE8D5F5);

  // Sepia surfaces
  static const sepiaBg = Color(0xFFF4ECD8);
  static const sepiaSurface = Color(0xFFFDF6E3);
  static const sepiaCard = Color(0xFFF5EDD8);
  static const sepiaBorder = Color(0xFFD4BB8E);
  static const sepiaText = Color(0xFF4A3B1A);

  // Text
  static const textOnDark = Color(0xFFEEEBFF);
  static const textOnLight = Color(0xFF1A0A33);
}

// ─── Reading Theme Enum ─────────────────────────────────────────────────────────
enum ReadingTheme { dark, light, sepia }

extension ReadingThemeX on ReadingTheme {
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

  Color get cardColor {
    switch (this) {
      case ReadingTheme.dark:
        return AppColors.darkCard;
      case ReadingTheme.light:
        return AppColors.lightSurface;
      case ReadingTheme.sepia:
        return AppColors.sepiaCard;
    }
  }

  Color get textColor {
    switch (this) {
      case ReadingTheme.dark:
        return AppColors.textOnDark;
      case ReadingTheme.light:
        return AppColors.textOnLight;
      case ReadingTheme.sepia:
        return AppColors.sepiaText;
    }
  }

  Color get subTextColor {
    switch (this) {
      case ReadingTheme.dark:
        return const Color(0xFF9B8EC4);
      case ReadingTheme.light:
        return const Color(0xFF6B5A8A);
      case ReadingTheme.sepia:
        return const Color(0xFF8B7355);
    }
  }

  Color get dialogueColor {
    switch (this) {
      case ReadingTheme.dark:
        return AppColors.lightLavender;
      case ReadingTheme.light:
        return AppColors.accentViolet;
      case ReadingTheme.sepia:
        return const Color(0xFF8B4513);
    }
  }

  Color get accentColor {
    switch (this) {
      case ReadingTheme.dark:
        return AppColors.accentPurple;
      case ReadingTheme.light:
        return AppColors.accentViolet;
      case ReadingTheme.sepia:
        return const Color(0xFF8B4513);
    }
  }

  Color get headerColor {
    switch (this) {
      case ReadingTheme.dark:
        return AppColors.darkSurface;
      case ReadingTheme.light:
        return const Color(0xFFF0E8FF);
      case ReadingTheme.sepia:
        return const Color(0xFFE8D8B8);
    }
  }

  Color get borderColor {
    switch (this) {
      case ReadingTheme.dark:
        return const Color(0xFF2E2B50);
      case ReadingTheme.light:
        return AppColors.lightBorder;
      case ReadingTheme.sepia:
        return AppColors.sepiaBorder;
    }
  }

  Color get progressColor {
    switch (this) {
      case ReadingTheme.dark:
        return AppColors.accentPurple;
      case ReadingTheme.light:
        return AppColors.accentViolet;
      case ReadingTheme.sepia:
        return const Color(0xFFA0522D);
    }
  }

  bool get isDark => this == ReadingTheme.dark;
  bool get isLight => this == ReadingTheme.light;
  bool get isSepia => this == ReadingTheme.sepia;

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
        return Icons.auto_stories_outlined;
    }
  }

  // Gradient for backgrounds
  LinearGradient get backgroundGradient {
    switch (this) {
      case ReadingTheme.dark:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0015), Color(0xFF12002E), Color(0xFF1A0533)],
        );
      case ReadingTheme.light:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F0FF), Color(0xFFFFF5F8), Color(0xFFF0F4FF)],
        );
      case ReadingTheme.sepia:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4ECD8), Color(0xFFFDF6E3), Color(0xFFEFE0C4)],
        );
    }
  }

  // Chapter image overlay shade
  Color get imageShade {
    switch (this) {
      case ReadingTheme.dark:
        return const Color(0x809B59B6); // purple
      case ReadingTheme.light:
        return const Color(0x407C3AED); // violet light
      case ReadingTheme.sepia:
        return const Color(0x60A0522D); // brown sepia
    }
  }
}
