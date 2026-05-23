import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── App Theme ────────────────────────────────────────────────────────────────
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A0015),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9B59B6),
        secondary: Color(0xFFEC4899),
        surface: Color(0xFF13102A),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFFEEEBFF),
      ),
      textTheme: GoogleFonts.notoSerifTextTheme(
        const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFEEEBFF)),
          bodySmall: TextStyle(color: Color(0xFF9B8EC4)),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F0FF),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF7C3AED),
        secondary: Color(0xFFEC4899),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1A0A33),
      ),
      textTheme: GoogleFonts.notoSerifTextTheme(
        const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF1A0A33)),
          bodySmall: TextStyle(color: Color(0xFF6B5A8A)),
        ),
      ),
    );
  }

  static ThemeData get sepiaTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF4ECD8),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8B4513),
        secondary: Color(0xFFA0522D),
        surface: Color(0xFFFDF6E3),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF4A3B1A),
      ),
      textTheme: GoogleFonts.notoSerifTextTheme(
        const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF4A3B1A)),
          bodySmall: TextStyle(color: Color(0xFF8B7355)),
        ),
      ),
    );
  }
}
