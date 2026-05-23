import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/reader/reader_screen.dart';


// ─── Liquid drop transition builder for go_router ──────────────────────────────
CustomTransitionPage<void> _dropPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 620),
    reverseTransitionDuration: const Duration(milliseconds: 460),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // ── Curves ──────────────────────────────────────────────────────────
      final enterCurve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      final exitCurve = CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeInCubic,
      );

      return Stack(
        children: [
          // Outgoing: frosted fade + subtle upward drift
          FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(exitCurve),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0, -0.035),
              ).animate(exitCurve),
              child: _DropImpactOverlay(progress: exitCurve),
            ),
          ),

          // Incoming: radial circular reveal + fade
          _RadialReveal(
            animation: enterCurve,
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.12, 1.0, curve: Curves.easeOut),
                ),
              ),
              child: child,
            ),
          ),
        ],
      );
    },
  );
}

// ─── Outgoing screen: expanding frosted ring impact ───────────────────────────
class _DropImpactOverlay extends StatelessWidget {
  final Animation<double> progress;
  const _DropImpactOverlay({required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final t = progress.value;
        return Stack(
          children: [
            child!,
            if (t > 0.01)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _ImpactRingPainter(t: t),
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

class _ImpactRingPainter extends CustomPainter {
  final double t;
  _ImpactRingPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.longestSide * 0.72;

    for (int i = 0; i < 4; i++) {
      final delay = i * 0.10;
      final wave = ((t - delay) / (1.0 - delay)).clamp(0.0, 1.0);
      if (wave <= 0) continue;

      final radius = maxR * wave;
      final alpha = ((1.0 - wave) * (0.20 - i * 0.04)).clamp(0.0, 1.0);

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.white.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8 - i * 0.3,
      );
    }
  }

  @override
  bool shouldRepaint(_ImpactRingPainter old) => old.t != t;
}

// ─── Incoming screen: circular clip reveal ─────────────────────────────────────
class _RadialReveal extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const _RadialReveal({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => ClipPath(
        clipper: _CircleClipper(animation.value),
        child: child,
      ),
      child: child,
    );
  }
}

class _CircleClipper extends CustomClipper<Path> {
  final double frac;
  _CircleClipper(this.frac);

  @override
  Path getClip(Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.longestSide * frac;
    return Path()..addOval(Rect.fromCircle(center: c, radius: r));
  }

  @override
  bool shouldReclip(_CircleClipper old) => old.frac != frac;
}

// ─── Router ────────────────────────────────────────────────────────────────────
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      pageBuilder: (context, state) =>
          _dropPage(state: state, child: const SplashScreen()),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) =>
          _dropPage(state: state, child: const HomeScreen()),
    ),
    GoRoute(
      path: '/read/:chapterId',
      name: 'reader',
      pageBuilder: (context, state) {
        final id = state.pathParameters['chapterId'] ?? '0';
        return _dropPage(
          state: state,
          child: ReaderScreen(chapterIndex: int.tryParse(id) ?? 0),
        );
      },
    ),
  ],
);

// ─── App Root ──────────────────────────────────────────────────────────────────
class AytilmaganGaplarApp extends StatelessWidget {
  const AytilmaganGaplarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp.router(
          title: 'Aytilmagan gaplar',
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.readingTheme == ReadingTheme.dark
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    );
  }
}
