import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── Water Drop Ripple Painter ──────────────────────────────────────────────────
// Paints multiple expanding translucent rings from a tap origin,
// simulating a droplet landing on a perfectly still surface.
class _WaterDropPainter extends CustomPainter {
  final List<_RippleWave> waves;
  final Color color;

  _WaterDropPainter({required this.waves, required this.color})
      : super(repaint: null);

  @override
  void paint(Canvas canvas, Size size) {
    for (final wave in waves) {
      final opacity = (1.0 - wave.progress).clamp(0.0, 1.0);
      final radius = wave.maxRadius * wave.progress;

      // Outer shimmer ring
      final shimmerPaint = Paint()
        ..color = color.withValues(alpha: opacity * 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 + (1 - wave.progress) * 2;
      canvas.drawCircle(wave.origin, radius, shimmerPaint);

      // Inner glow ring (tighter, faster fade)
      if (wave.progress < 0.6) {
        final innerOpacity = (1.0 - wave.progress / 0.6).clamp(0.0, 1.0);
        final innerPaint = Paint()
          ..color = color.withValues(alpha: innerOpacity * 0.28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;
        canvas.drawCircle(wave.origin, radius * 0.55, innerPaint);
      }

      // Central liquid fill dot (appears and shrinks quickly)
      if (wave.progress < 0.25) {
        final dotOpacity = (1.0 - wave.progress / 0.25).clamp(0.0, 1.0);
        final dotPaint = Paint()
          ..color = color.withValues(alpha: dotOpacity * 0.35)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(wave.origin, (1 - wave.progress) * 6, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_WaterDropPainter oldDelegate) => true;
}

// ─── Ripple Wave Data ─────────────────────────────────────────────────────────
class _RippleWave {
  final Offset origin;
  final double maxRadius;
  double progress = 0.0; // animated from 0.0 → 1.0 by controller

  _RippleWave({required this.origin, required this.maxRadius});
}

// ─── Water Drop Ripple Widget ──────────────────────────────────────────────────
class WaterDropRipple extends StatefulWidget {
  final Widget child;
  final Color? rippleColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;

  const WaterDropRipple({
    super.key,
    required this.child,
    this.rippleColor,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
  });

  @override
  State<WaterDropRipple> createState() => _WaterDropRippleState();
}

class _WaterDropRippleState extends State<WaterDropRipple>
    with TickerProviderStateMixin {
  final List<_RippleWave> _waves = [];
  final List<AnimationController> _controllers = [];

  void _spawnRipple(Offset localPosition, Size size) {
    final maxDim = math.max(size.width, size.height);
    final maxRadius = maxDim * 0.85;

    final wave = _RippleWave(origin: localPosition, maxRadius: maxRadius);

    final ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    );

    ctrl.addListener(() {
      if (mounted) {
        setState(() => wave.progress = ctrl.value);
      }
    });

    ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _waves.remove(wave);
            _controllers.remove(ctrl);
          });
        }
        ctrl.dispose();
      }
    });

    setState(() {
      _waves.add(wave);
      _controllers.add(ctrl);
    });

    ctrl.forward();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rippleColor = widget.rippleColor ??
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.7);

    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          _spawnRipple(details.localPosition, box.size);
        }
      },
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: Stack(
          children: [
            widget.child,
            if (_waves.isNotEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _WaterDropPainter(
                      waves: List.from(_waves),
                      color: rippleColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
