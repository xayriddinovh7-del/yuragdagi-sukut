import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Water Drop Page Transition
//
// EXIT:  The outgoing screen dissolves behind a radial frosted-glass "drop"
//        that expands from the center outward — like a raindrop hitting glass.
// ENTER: The incoming screen ripple-fades in from 0 opacity + slight blur,
//        accompanied by a circular reveal expanding from the impact center.
// ─────────────────────────────────────────────────────────────────────────────

class WaterDropPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Alignment origin;

  WaterDropPageRoute({
    required this.page,
    this.origin = Alignment.center,
    super.settings,
  }) : super(
          transitionDuration: const Duration(milliseconds: 620),
          reverseTransitionDuration: const Duration(milliseconds: 480),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: _buildTransition,
        );

  static Widget _buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // ── Curves ────────────────────────────────────────────────────────────
    final enterCurve =
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    final exitCurve = CurvedAnimation(
        parent: secondaryAnimation, curve: Curves.easeInCubic);

    return Stack(
      children: [
        // ── Outgoing screen: fade + upward drift + frosted shrink ─────────
        FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(exitCurve),
          child: SlideTransition(
            position:
                Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.04))
                    .animate(exitCurve),
            child: _FrostedExit(progress: exitCurve),
          ),
        ),

        // ── Incoming screen: radial liquid reveal ─────────────────────────
        _RadialReveal(
          animation: enterCurve,
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

// ─── Frosted Exit Overlay ──────────────────────────────────────────────────────
// As the page is pushed away, a quickly spreading frosted ring simulates
// the impact surface of a water drop — then fades out.
class _FrostedExit extends StatelessWidget {
  final Animation<double> progress;
  const _FrostedExit({required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final t = progress.value;
        if (t < 0.01) return child!;
        return Stack(
          children: [
            child!,
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _DropImpactPainter(progress: t),
                ),
              ),
            ),
            // Frosted blur overlay — appears then fades
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: (t * 2.0).clamp(0.0, 1.0) *
                      ((1.0 - t) * 2.0).clamp(0.0, 1.0),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: 8 * t,
                      sigmaY: 8 * t,
                    ),
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.04 * t),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: const SizedBox.expand(),
    );
  }
}

// ─── Drop Impact Painter ───────────────────────────────────────────────────────
class _DropImpactPainter extends CustomPainter {
  final double progress;
  _DropImpactPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.longestSide * 0.7;

    // Expanding ring count — staggered offsets
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.12;
      final t = ((progress - delay) / (1.0 - delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final radius = maxR * t;
      final opacity = (1.0 - t) * (0.18 - i * 0.04);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 - i * 0.3;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_DropImpactPainter old) => old.progress != progress;
}

// ─── Radial Reveal Clipper ─────────────────────────────────────────────────────
class _RadialReveal extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _RadialReveal({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: _CircleRevealClipper(fraction: animation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _CircleRevealClipper extends CustomClipper<Path> {
  final double fraction;
  _CircleRevealClipper({required this.fraction});

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.longestSide * fraction;
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(_CircleRevealClipper old) => old.fraction != fraction;
}
