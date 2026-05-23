import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── Rain Drop Model ────────────────────────────────────────────────────────────
class RainDrop {
  double x;
  double y;
  final double speed;
  final double opacity;
  final double length;

  RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.opacity,
    required this.length,
  });
}

// ─── Rain Painter ───────────────────────────────────────────────────────────────
class RainPainter extends CustomPainter {
  final double animationValue;
  final bool isDark;
  final List<RainDrop> drops;

  RainPainter({
    required this.animationValue,
    required this.isDark,
    required this.drops,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final drop in drops) {
      // Advance drop position
      drop.y += drop.speed * 0.016 * 300;
      drop.x += drop.speed * 0.016 * 300 * 0.12; // slight wind angle

      if (drop.y > size.height + 30) {
        drop.y = -drop.length;
        drop.x = math.Random().nextDouble() * size.width;
      }
      if (drop.x > size.width) {
        drop.x -= size.width;
      }

      final paint = Paint()
        ..color = (isDark ? Colors.white : const Color(0xFF9B59B6))
            .withValues(alpha: drop.opacity)
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(drop.x, drop.y),
        Offset(drop.x + drop.length * 0.12, drop.y + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RainPainter oldDelegate) => true;
}

// ─── Rain Animation Widget ─────────────────────────────────────────────────────
class RainAnimation extends StatefulWidget {
  final bool isDark;
  final bool enabled;

  const RainAnimation({super.key, this.isDark = true, this.enabled = true});

  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _rng = math.Random();
  late List<RainDrop> _drops;

  @override
  void initState() {
    super.initState();
    _drops = List.generate(150, (_) => _makeDrop(initial: true));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();
  }

  RainDrop _makeDrop({bool initial = false}) {
    return RainDrop(
      x: _rng.nextDouble() * 2000,
      y: initial ? _rng.nextDouble() * 1500 : -30,
      speed: 2.0 + _rng.nextDouble() * 4.0,
      opacity: 0.08 + _rng.nextDouble() * 0.25,
      length: 15 + _rng.nextDouble() * 10,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        painter: RainPainter(
          animationValue: _controller.value,
          isDark: widget.isDark,
          drops: _drops,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
