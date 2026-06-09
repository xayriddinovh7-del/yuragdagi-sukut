import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── Floating Orb ─────────────────────────────────────────────────────────────
class _OrbConfig {
  final Color color;
  final double size;
  final Alignment alignment;
  final Duration duration;
  final double offsetRange;

  const _OrbConfig({
    required this.color,
    required this.size,
    required this.alignment,
    required this.duration,
    this.offsetRange = 50,
  });
}

const _orbs = [
  _OrbConfig(
    color: Color(0xFF7C3AED),
    size: 500,
    alignment: Alignment(-0.8, -0.7),
    duration: Duration(seconds: 8),
    offsetRange: 60,
  ),
  _OrbConfig(
    color: Color(0xFFEC4899),
    size: 350,
    alignment: Alignment(0.8, -0.6),
    duration: Duration(seconds: 12),
    offsetRange: 50,
  ),
  _OrbConfig(
    color: Color(0xFF9B59B6),
    size: 600,
    alignment: Alignment(0, 0.8),
    duration: Duration(seconds: 15),
    offsetRange: 70,
  ),
  _OrbConfig(
    color: Color(0xFF3B82F6),
    size: 250,
    alignment: Alignment(-0.4, 0.3),
    duration: Duration(seconds: 10),
    offsetRange: 40,
  ),
  _OrbConfig(
    color: Color(0xFFF59E0B),
    size: 200,
    alignment: Alignment(0.5, 0.2),
    duration: Duration(seconds: 14),
    offsetRange: 45,
  ),
];

class FloatingOrbs extends StatefulWidget {
  const FloatingOrbs({super.key});

  @override
  State<FloatingOrbs> createState() => _FloatingOrbsState();
}

class _FloatingOrbsState extends State<FloatingOrbs>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _orbs.length; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: _orbs[i].duration,
      );
      final anim = Tween<double>(begin: 0, end: 1).animate(ctrl);
      ctrl.repeat(reverse: true);
      // Stagger start
      Future.delayed(Duration(milliseconds: _rng.nextInt(3000)), () {
        if (mounted) ctrl.forward();
      });
      _controllers.add(ctrl);
      _animations.add(anim);
    }
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
    return Stack(
      children: List.generate(_orbs.length, (i) {
        final orb = _orbs[i];
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) {
            final t = _animations[i].value;
            final dx = (math.sin(t * math.pi * 2) * orb.offsetRange);
            final dy = (math.cos(t * math.pi * 2 + i) * orb.offsetRange);
            return Align(
              alignment: orb.alignment,
              child: Transform.translate(
                offset: Offset(dx, dy),
                child: Container(
                  width: orb.size,
                  height: orb.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        orb.color.withValues(alpha: 0.18),
                        orb.color.withValues(alpha: 0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
