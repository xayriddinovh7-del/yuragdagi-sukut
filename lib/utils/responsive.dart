import 'package:flutter/material.dart';

/// Breakpoints:
///   compact  : < 480px   — kichik telefonlar
///   mobile   : 480–719px — standart telefonlar
///   tablet   : 720–959px — planshetlar
///   desktop  : ≥ 960px   — desktoplar
class Responsive {
  final double width;

  const Responsive._(this.width);

  factory Responsive.of(BuildContext context) =>
      Responsive._(MediaQuery.sizeOf(context).width);

  bool get isCompact => width < 480;
  bool get isMobile  => width >= 480 && width < 720;
  bool get isTablet  => width >= 720 && width < 960;
  bool get isDesktop => width >= 960;

  /// Kichik ekrandan kattaga qarab 4 qiymatdan birini qaytaradi.
  /// [compact] — < 480, [mobile] — 480-719,
  /// [tablet]  — 720-959, [desktop] — ≥ 960
  T value<T>({
    required T compact,
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isDesktop) return desktop;
    if (isTablet)  return tablet;
    if (isMobile)  return mobile;
    return compact;
  }

  /// 2-qiymatli variant: mobile vs desktop
  T twoWay<T>({required T mobile, required T desktop}) {
    return isDesktop ? desktop : mobile;
  }

  // ─── Tez-ishlatiladigan dimension helper'lar ─────────────────────

  /// Horizontal sahifa padding
  double get hPadding => value(compact: 14.0, mobile: 20.0, tablet: 32.0, desktop: 48.0);

  /// Top-bar matn o'lchami
  double get topBarFontSize => value(compact: 14.0, mobile: 16.0, tablet: 18.0, desktop: 20.0);

  /// Splash title o'lchami
  double get splashTitleSize => value(compact: 32.0, mobile: 42.0, tablet: 52.0, desktop: 60.0);

  /// Splash subtitle o'lchami
  double get splashSubtitleSize => value(compact: 12.0, mobile: 14.0, tablet: 16.0, desktop: 18.0);

  /// Chapter card thumbnail kengligi
  double get chapterThumbWidth => value(compact: 72.0, mobile: 90.0, tablet: 110.0, desktop: 120.0);

  /// Chapter card thumbnail balandligi
  double get chapterThumbHeight => value(compact: 80.0, mobile: 100.0, tablet: 110.0, desktop: 120.0);

  /// Chapter card title font o'lchami
  double get chapterTitleSize => value(compact: 14.0, mobile: 15.0, tablet: 17.0, desktop: 18.0);

  /// Mobile stats card kitob cover balandligi
  double get statsCardCoverHeight => value(compact: 65.0, mobile: 80.0, tablet: 95.0, desktop: 100.0);
  double get statsCardCoverWidth  => value(compact: 45.0, mobile: 58.0, tablet: 68.0, desktop: 72.0);

  /// Reader header image balandligi
  double get readerHeaderHeight => value(compact: 160.0, mobile: 200.0, tablet: 240.0, desktop: 280.0);

  /// Settings drawer kengligi
  double get settingsDrawerWidth => value(compact: double.infinity, mobile: double.infinity, tablet: 360.0, desktop: 380.0);

  /// Icon button o'lchami
  double get iconButtonSize => value(compact: 36.0, mobile: 38.0, tablet: 40.0, desktop: 40.0);
  double get iconSize       => value(compact: 16.0, mobile: 17.0, tablet: 18.0, desktop: 18.0);

  /// Sidebar kengligi (reader desktop sidebar)
  double get readerSidebarWidth => value(compact: 0.0, mobile: 0.0, tablet: 260.0, desktop: 320.0);

  /// Minimum splash quote font o'lchami
  double get splashQuoteFontSize => value(compact: 13.0, mobile: 14.0, tablet: 16.0, desktop: 16.0);
}
