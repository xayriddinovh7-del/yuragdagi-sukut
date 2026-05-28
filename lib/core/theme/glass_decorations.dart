import 'dart:ui';
import 'package:flutter/material.dart';

// ─── Glass Decoration Helpers ──────────────────────────────────────────────────
// Reusable BoxDecoration for glass morphism effects

class GlassDecorations {
  // Dark glass card
  static BoxDecoration darkCard({
    double radius = 24,
    double borderOpacity = 0.15,
    double bgOpacity = 0.08,
    Color? glowColor,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: bgOpacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withValues(alpha: borderOpacity),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: (glowColor ?? const Color(0xFF9B59B6)).withValues(alpha: 0.15),
          blurRadius: 40,
          spreadRadius: -5,
          offset: const Offset(0, 20),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.30),
          blurRadius: 60,
          offset: const Offset(0, 30),
        ),
      ],
    );
  }

  // Light glass card
  static BoxDecoration lightCard({
    double radius = 24,
    double borderOpacity = 0.7,
    double bgOpacity = 0.5,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: bgOpacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withValues(alpha: borderOpacity),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF9B59B6).withValues(alpha: 0.08),
          blurRadius: 30,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Nav bar glass
  static BoxDecoration navBar({bool isDark = true}) {
    return BoxDecoration(
      color: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.white.withValues(alpha: 0.7),
      border: Border(
        bottom: BorderSide(
          color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.5),
        ),
      ),
    );
  }

  // Sidebar glass
  static BoxDecoration sidebar() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.06),
      border: Border(
        right: BorderSide(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}

// ─── BackdropFilter Wrapper ────────────────────────────────────────────────────
class GlassWidget extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final BoxDecoration decoration;
  final BorderRadius? borderRadius;

  const GlassWidget({
    super.key,
    required this.child,
    required this.decoration,
    this.sigmaX = 20,
    this.sigmaY = 20,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(24);
    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}
