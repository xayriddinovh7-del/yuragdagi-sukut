import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/image_urls.dart';
import '../../painters/rain_painter.dart';
import '../../painters/floating_orbs.dart';
import '../../providers/reading_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/constants/translations.dart';
import '../../widgets/glass_widgets.dart';
import '../../utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Sequence state flags
  bool _bgVisible = false;
  bool _rainVisible = false;
  bool _orbsVisible = false;
  bool _titleVisible = false;
  bool _subtitleVisible = false;
  bool _quoteVisible = false;
  bool _ctaVisible = false;
  bool _hoverCta = false;

  // Blur animation for background
  late AnimationController _blurController;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();

    _blurController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _blurAnimation = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _blurController, curve: Curves.easeOut),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // 300ms → background fades in
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _bgVisible = true);
    _blurController.forward();

    // 1500ms → rain
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _rainVisible = true);

    // 2000ms → orbs
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _orbsVisible = true);

    // 2500ms → title
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _titleVisible = true);

    // 3200ms → subtitle
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _subtitleVisible = true);

    // 3800ms → quote
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _quoteVisible = true);

    // 4500ms → Auto-enter
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    _enter();
  }

  void _enter() async {
    final readingProvider =
        Provider.of<ReadingProvider>(context, listen: false);
    await readingProvider.markSplashDone();
    if (!mounted) return;
    context.go('/home');
  }

  @override
  void dispose() {
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final lang = settings.language;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background image ─────────────────────────────────────────────
          AnimatedOpacity(
            opacity: _bgVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 2000),
            child: AnimatedBuilder(
              animation: _blurAnimation,
              builder: (_, child) => ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
                child: child,
              ),
              child: Image.asset(
                ImageUrls.splashBg,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    const ColoredBox(color: Color(0xFF0A0015)),
              ),
            ),
          ),

          // Dark gradient overlay
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.45),
                  Colors.black.withValues(alpha: 0.65),
                  const Color(0xFF0A0015).withValues(alpha: 0.85),
                ],
              ),
            ),
          ),

          // ── Floating orbs ─────────────────────────────────────────────────
          AnimatedOpacity(
            opacity: _orbsVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1200),
            child: const FloatingOrbs(),
          ),

          // ── Rain ─────────────────────────────────────────────────────────
          AnimatedOpacity(
            opacity: _rainVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000),
            child: const RainAnimation(isDark: true, enabled: true),
          ),

          // ── Main content ─────────────────────────────────────────────────
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.of(context).hPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Book icon
                    if (_titleVisible)
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 48,
                        color: Color(0xFF9B59B6),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(
                            begin: const Offset(0, 0),
                            duration: 700.ms,
                            curve: Curves.elasticOut,
                          ),

                    const SizedBox(height: 24),

                    // Title
                    if (_titleVisible)
                      Builder(
                        builder: (context) {
                          final r = Responsive.of(context);
                          return Text(
                            AppLocalizations.get('app_title', lang),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: r.splashTitleSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.15,
                              letterSpacing: -0.5,
                              shadows: [
                                Shadow(
                                  color: const Color(0xFF9B59B6)
                                      .withValues(alpha: 0.6),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .slideY(
                                begin: 0.4,
                                end: 0,
                                duration: 800.ms,
                                curve: Curves.easeOutCubic,
                              )
                              .fadeIn(duration: 700.ms);
                        },
                      ),

                    const SizedBox(height: 12),

                    // Subtitle
                    if (_subtitleVisible)
                      Builder(
                        builder: (context) {
                          final r = Responsive.of(context);
                          return Text(
                            AppLocalizations.get('subtitle', lang),
                            style: GoogleFonts.lato(
                              fontSize: r.splashSubtitleSize,
                              color: const Color(0xFFEC4899)
                                  .withValues(alpha: 0.85),
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ).animate().fadeIn(duration: 700.ms);
                        },
                      ),

                    const SizedBox(height: 40),

                    // Quote
                    if (_quoteVisible)
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        bgOpacity: 0.12,
                        borderOpacity: 0.20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 3,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFF9B59B6),
                                    const Color(0xFFEC4899)
                                        .withValues(alpha: 0.5),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final r = Responsive.of(context);
                                  return Text(
                                    AppLocalizations.get('quote', lang),
                                    style: GoogleFonts.notoSerif(
                                      fontSize: r.splashQuoteFontSize,
                                      color: Colors.white.withValues(alpha: 0.80),
                                      height: 1.7,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 800.ms)
                          .slideX(
                            begin: -0.05,
                            end: 0,
                            duration: 800.ms,
                            curve: Curves.easeOutCubic,
                          ),

                    const SizedBox(height: 48),

                    // CTA Button
                    if (_ctaVisible)
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => _hoverCta = true),
                        onExit: (_) => setState(() => _hoverCta = false),
                        child: GestureDetector(
                          onTap: _enter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            transform: Matrix4.diagonal3Values(
                              _hoverCta ? 1.04 : 1.0,
                              _hoverCta ? 1.04 : 1.0,
                              1.0,
                            ),
                            transformAlignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _hoverCta
                                          ? [
                                              const Color(0xFFAB68D0),
                                              const Color(0xFFEC4899),
                                            ]
                                          : [
                                              const Color(0xFF9B59B6),
                                              const Color(0xFF7C3AED),
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: _hoverCta
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF9B59B6)
                                                  .withValues(alpha: 0.55),
                                              blurRadius: 30,
                                              spreadRadius: 4,
                                            ),
                                          ]
                                        : [
                                            BoxShadow(
                                              color: const Color(0xFF9B59B6)
                                                  .withValues(alpha: 0.30),
                                              blurRadius: 20,
                                            ),
                                          ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppLocalizations.get('start_reading', lang),
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 220),
                                        transform: Matrix4.translationValues(
                                            _hoverCta ? 4 : 0, 0, 0),
                                        child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 700.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 700.ms,
                            curve: Curves.easeOutCubic,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}