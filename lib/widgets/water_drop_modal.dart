import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// ─── Water Drop Modal Painter ────────────────────────────────────────────────
// Paints expanding concentric ripple waves simulating a drop of water falling on the screen.
class _ModalRipplePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isExit;

  _ModalRipplePainter({
    required this.progress,
    required this.color,
    required this.isExit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.longestSide * 0.6;

    // We paint 3 staggered rings
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.15;
      double t;
      if (isExit) {
        // Exit ripple goes backwards or expands and fades
        t = ((progress - delay) / (1.0 - delay)).clamp(0.0, 1.0);
      } else {
        t = ((progress - delay) / (1.0 - delay)).clamp(0.0, 1.0);
      }
      if (t <= 0) continue;

      final radius = maxRadius * t;
      final opacity = (1.0 - t) * (0.22 - i * 0.05);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 - i * 0.5;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ModalRipplePainter old) =>
      old.progress != progress || old.color != color || old.isExit != isExit;
}

// ─── Custom Bottom Sheet Route ──────────────────────────────────────────────
class WaterDropBottomSheetRoute<T> extends PopupRoute<T> {
  final WidgetBuilder builder;
  final Color? rippleColor;

  WaterDropBottomSheetRoute({
    required this.builder,
    this.rippleColor,
    super.settings,
  });

  @override
  Color? get barrierColor => Colors.black.withValues(alpha: 0.25);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Water Drop Bottom Sheet';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 550);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 400);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final isClosing = animation.status == AnimationStatus.reverse;
    final progressVal = animation.value;
    final rColor = rippleColor ?? Theme.of(context).colorScheme.primary;

    // Background blur + liquid ripples
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 12 * progressVal,
                sigmaY: 12 * progressVal,
              ),
              child: CustomPaint(
                painter: _ModalRipplePainter(
                  progress: progressVal,
                  color: rColor,
                  isExit: isClosing,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            )),
            child: child,
          ),
        ),
      ],
    );
  }
}

// ─── Custom Dialog Route ─────────────────────────────────────────────────────
class WaterDropDialogRoute<T> extends PopupRoute<T> {
  final WidgetBuilder builder;
  final Color? rippleColor;

  WaterDropDialogRoute({
    required this.builder,
    this.rippleColor,
    super.settings,
  });

  @override
  Color? get barrierColor => Colors.black.withValues(alpha: 0.3);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Water Drop Dialog';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 450);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final isClosing = animation.status == AnimationStatus.reverse;
    final progressVal = animation.value;
    final rColor = rippleColor ?? Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 10 * progressVal,
                sigmaY: 10 * progressVal,
              ),
              child: CustomPaint(
                painter: _ModalRipplePainter(
                  progress: progressVal,
                  color: rColor,
                  isExit: isClosing,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeIn,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Helper Functions ────────────────────────────────────────────────────────
Future<T?> showWaterDropBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? rippleColor,
}) {
  return Navigator.of(context).push(
    WaterDropBottomSheetRoute<T>(
      builder: builder,
      rippleColor: rippleColor,
    ),
  );
}

Future<T?> showWaterDropDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? rippleColor,
}) {
  return Navigator.of(context).push(
    WaterDropDialogRoute<T>(
      builder: builder,
      rippleColor: rippleColor,
    ),
  );
}
