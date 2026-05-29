import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/book_data.dart' as book;
import '../../providers/reading_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/image_urls.dart';
import '../../painters/rain_painter.dart';
import '../../painters/floating_orbs.dart';
import '../../widgets/glass_widgets.dart';

import '../../widgets/bookmark_panel.dart';
import '../../widgets/settings_drawer.dart';
import '../../widgets/water_drop_modal.dart';
import '../../widgets/water_drop_ripple.dart';
import '../../core/constants/translations.dart';
import '../../utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  int _getWordCount(String content) {
    return content.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }

  int _getEstimatedMinutes(String content) {
    return (_getWordCount(content) / 200).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final readingProv = Provider.of<ReadingProvider>(context);
    final settingsProv = Provider.of<SettingsProvider>(context);
    final bookmarkProv = Provider.of<BookmarkProvider>(context);

    final theme = settingsProv.readingTheme;
    final bg = theme.bgColor;
    final textColor = theme.textColor;
    final subColor = theme.subTextColor;
    final accent = theme.accentColor;
    final isDark = theme.isDark;

    final mediaQuery = MediaQuery.of(context);
    final r = Responsive.of(context);
    final isDesktop = r.isDesktop;
    final isTablet = r.isTablet;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background Image (with scroll parallax) ─────────────────────
          Positioned(
            top: -(_scrollOffset * 0.3),
            left: 0,
            right: 0,
            height: mediaQuery.size.height * 1.5,
            child: Opacity(
              opacity: isDark ? 0.35 : 0.12,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Image.asset(
                  ImageUrls.homeBg,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: bg),
                ),
              ),
            ),
          ),

          // Deep Gradient Shade Layer
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: theme.backgroundGradient,
              ),
            ),
          ),

          // ── Ambient Floating Orbs ─────────────────────────────────────────
          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.6 : 0.3,
              child: const FloatingOrbs(),
            ),
          ),

          // ── Rain Animation ──────────────────────────────────────────────
          Positioned.fill(
            child: RainAnimation(isDark: isDark, enabled: true),
          ),

          // ── Main UI Layout ───────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Frosted Glass Bar
                _buildTopBar(context, settingsProv, bookmarkProv, readingProv,
                    textColor, accent, isDark),

                // Content Panel (Split sidebar & list on desktop)
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: r.hPadding,
                      vertical: 24.0,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left Sidebar
                                  Expanded(
                                    flex: 3,
                                    child: _buildSidebar(
                                        context,
                                        readingProv,
                                        settingsProv,
                                        textColor,
                                        subColor,
                                        accent,
                                        isDark),
                                  ),
                                  const SizedBox(width: 32),
                                  // Right Chapters List
                                  Expanded(
                                    flex: 7,
                                    child: _buildChaptersSection(
                                        context,
                                        readingProv,
                                        settingsProv,
                                        textColor,
                                        subColor,
                                        accent,
                                        isDark),
                                  ),
                                ],
                              )
                            : isTablet
                                // Tablet: ikki ustun, kichikroq sidebar
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 240,
                                        child: _buildSidebar(
                                            context,
                                            readingProv,
                                            settingsProv,
                                            textColor,
                                            subColor,
                                            accent,
                                            isDark),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: _buildChaptersSection(
                                            context,
                                            readingProv,
                                            settingsProv,
                                            textColor,
                                            subColor,
                                            accent,
                                            isDark),
                                      ),
                                    ],
                                  )
                                // Mobile/Compact: vertikal stack
                                : Column(
                                    children: [
                                      // Stats summary
                                      _buildMobileStatsCard(
                                          readingProv,
                                          settingsProv,
                                          textColor,
                                          subColor,
                                          accent,
                                          isDark),
                                      const SizedBox(height: 24),
                                      // Chapters List
                                      _buildChaptersSection(
                                          context,
                                          readingProv,
                                          settingsProv,
                                          textColor,
                                          subColor,
                                          accent,
                                          isDark),
                                    ],
                                  ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Action Button
          if (readingProv.readChapters.isNotEmpty)
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.pushNamed(
                    'reader',
                    pathParameters: {
                      'chapterId': readingProv.currentChapter.toString()
                    },
                  );
                },
                backgroundColor: accent,
                foregroundColor: Colors.white,
                elevation: 12,
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(
                  AppLocalizations.get(
                      'continue_reading', settingsProv.language),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ).animate().scale(curve: Curves.elasticOut, duration: 800.ms),
            ),
        ],
      ),
    );
  }

  // ─── Top Frosted Navigation Bar ──────────────────────────────────────────────
  Widget _buildTopBar(
    BuildContext context,
    SettingsProvider settings,
    BookmarkProvider bookmarks,
    ReadingProvider reading,
    Color textColor,
    Color accent,
    bool isDark,
  ) {
    return GlassCard(
      borderRadius: 0,
      bgOpacity: 0.05,
      borderOpacity: 0.08,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.menu_book_rounded, color: accent, size: 24)
              .animate()
              .scale(duration: 400.ms),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              book.BookData.getTitle(settings.language),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.playfairDisplay(
                fontSize: Responsive.of(context).topBarFontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Spacer(),
          // Settings pill button
          GlassPillIconButton(
            icon: Icons.tune_rounded,
            tooltip: AppLocalizations.get('settings', settings.language),
            color: textColor.withValues(alpha: 0.8),
            onTap: () {
              showWaterDropBottomSheet(
                context: context,
                builder: (_) => const SettingsDrawer(),
              );
            },
          ),
          const SizedBox(width: 8),
          // Bookmarks pill button
          GlassPillIconButton(
            icon: Icons.bookmarks_outlined,
            tooltip: AppLocalizations.get('bookmarks', settings.language),
            color: textColor.withValues(alpha: 0.8),
            onTap: () {
              showWaterDropBottomSheet(
                context: context,
                builder: (_) => BookmarkPanel(
                  onNavigate: (chIdx, pIdx) {
                    context.pushNamed(
                      'reader',
                      pathParameters: {'chapterId': chIdx.toString()},
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          // Theme toggler
          GlassPillIconButton(
            icon: settings.readingTheme.icon,
            tooltip: AppLocalizations.get('theme', settings.language),
            color: textColor.withValues(alpha: 0.8),
            onTap: () {
              settings.cycleTheme();
            },
          ),
        ],
      ),
    );
  }

  // ─── Desktop Sidebar ────────────────────────────────────────────────────────
  Widget _buildSidebar(
    BuildContext context,
    ReadingProvider reading,
    SettingsProvider settings,
    Color textColor,
    Color subColor,
    Color accent,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Book Cover Card
        GlassCard(
          padding: const EdgeInsets.all(20),
          bgOpacity: 0.08,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 240,
                  width: 170,
                  child: Image.asset(
                    ImageUrls.bookCover,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF13102A),
                      child: const Icon(Icons.book, size: 48),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
              const SizedBox(height: 18),
              Text(
                book.BookData.getTitle(settings.language),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                book.BookData.getDescription(settings.language),
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: subColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              const GlowLine(width: 100, color: Color(0xFF9B59B6)),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Statistics panel
        GlassCard(
          padding: const EdgeInsets.all(20),
          bgOpacity: 0.06,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.get('progress', settings.language)
                    .toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: subColor,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${AppLocalizations.get('total_time', settings.language)}:',
                      style: GoogleFonts.lato(fontSize: 13, color: textColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    reading.readingTimeText(settings.language),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: accent,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, color: Colors.white10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${AppLocalizations.get('chapters_read', settings.language)}:',
                      style: GoogleFonts.lato(fontSize: 13, color: textColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${reading.readChapters.length} / ${book.BookData.getChapters(settings.language).length}',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Linear Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: reading.progress,
                  minHeight: 6,
                  backgroundColor: isDark ? Colors.white12 : Colors.black12,
                  valueColor: AlwaysStoppedAnimation(accent),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  reading.progressText(settings.language),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: subColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Clean stats actions
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          bgOpacity: 0.05,
          child: ListTile(
            leading:
                Icon(Icons.delete_sweep_outlined, color: subColor, size: 20),
            title: Text(
              AppLocalizations.get('clear_history', settings.language),
              style: GoogleFonts.lato(fontSize: 13, color: textColor),
            ),
            onTap: () => _showResetDialog(context, reading, settings, isDark),
          ),
        ),
      ],
    );
  }

  // ─── Mobile Statistics Card ─────────────────────────────────────────────────
  Widget _buildMobileStatsCard(
    ReadingProvider reading,
    SettingsProvider settings,
    Color textColor,
    Color subColor,
    Color accent,
    bool isDark,
  ) {
    final chLen = book.BookData.getChapters(settings.language).length;
    final r = Responsive.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(20),
      bgOpacity: 0.08,
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: r.statsCardCoverHeight,
                  width: r.statsCardCoverWidth,
                  child: Image.asset(
                    ImageUrls.bookCover,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFF13102A)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.BookData.getTitle(settings.language),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.BookData.getDescription(settings.language),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time_rounded,
                                size: 12, color: subColor),
                            const SizedBox(width: 4),
                            Text(
                              reading.readingTimeText(settings.language),
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_stories_outlined,
                                size: 12, color: subColor),
                            const SizedBox(width: 4),
                            Text(
                              '${reading.readChapters.length}/$chLen ${AppLocalizations.get('chapter', settings.language).toLowerCase()}',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: reading.progress,
              minHeight: 4,
              backgroundColor: isDark ? Colors.white10 : Colors.black12,
              valueColor: AlwaysStoppedAnimation(accent),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Chapters List Section ───────────────────────────────────────────────────
  Widget _buildChaptersSection(
    BuildContext context,
    ReadingProvider reading,
    SettingsProvider settings,
    Color textColor,
    Color subColor,
    Color accent,
    bool isDark,
  ) {
    final chaptersList = book.BookData.getChapters(settings.language);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 16),
          child: Text(
            AppLocalizations.get('chapters_list', settings.language),
            style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.8,
              color: subColor,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chaptersList.length,
          itemBuilder: (context, index) {
            final chapter = chaptersList[index];
            final isRead = reading.isChapterRead(index);
            final isCurrent = reading.currentChapter == index;
            final words = _getWordCount(chapter.content);
            final minutes = _getEstimatedMinutes(chapter.content);

            return _buildChapterCard(
              context,
              index,
              chapter,
              isRead,
              isCurrent,
              words,
              minutes,
              reading,
              settings,
              textColor,
              subColor,
              accent,
              isDark,
            ).animate().fadeIn(delay: (index * 80).ms).slideY(
                begin: 0.1,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutCubic);
          },
        ),
      ],
    );
  }

  // ─── Chapter Card — Vertikal: rasm yuqorida, matn pastda ─────────────────────
  Widget _buildChapterCard(
    BuildContext context,
    int index,
    book.Chapter chapter,
    bool isRead,
    bool isCurrent,
    int wordCount,
    int readMinutes,
    ReadingProvider reading,
    SettingsProvider settings,
    Color textColor,
    Color subColor,
    Color accent,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ],
      ),
      child: GlassCard(
        padding: EdgeInsets.zero,
        bgOpacity: isCurrent ? 0.14 : 0.07,
        borderOpacity: isCurrent ? 0.30 : 0.12,
        borderRadius: 24,
        child: WaterDropRipple(
          borderRadius: BorderRadius.circular(24),
          onTap: () async {
            await reading.setCurrentChapter(index);
            if (context.mounted) {
              context.pushNamed(
                'reader',
                pathParameters: {'chapterId': index.toString()},
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Yuqori qism: rasm to'liq kenglikda ────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: SizedBox(
                  height: 180,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Asosiy rasm
                      Image.asset(
                        ImageUrls.chapterImage(index),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF2D1B69),
                                accent.withValues(alpha: 0.4),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.auto_stories_rounded,
                              color: Colors.white.withValues(alpha: 0.3),
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                      // Gradiyent overlay — pastdan yuqoriga
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.10),
                                Colors.black.withValues(alpha: 0.65),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Bob raqami — yuqori chap burchak
                      Positioned(
                        top: 14,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${AppLocalizations.get('chapter', settings.language).toUpperCase()} ${index + 1}',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // O'qilgan / Joriy holat — yuqori o'ng burchak
                      Positioned(
                        top: 12,
                        right: 14,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isRead
                                ? Colors.green.withValues(alpha: 0.85)
                                : isCurrent
                                    ? accent.withValues(alpha: 0.85)
                                    : Colors.black.withValues(alpha: 0.35),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3)),
                          ),
                          child: Center(
                            child: Icon(
                              isRead
                                  ? Icons.check_rounded
                                  : isCurrent
                                      ? Icons.play_arrow_rounded
                                      : Icons.lock_open_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Bob nomi — rasmdagi pastki qism
                      Positioned(
                        bottom: 14,
                        left: 16,
                        right: 16,
                        child: Text(
                          chapter.title,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.7),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Pastki qism: statistika va o'qish tugmasi ─────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    // So'zlar soni
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notes_rounded, size: 13, color: subColor),
                        const SizedBox(width: 5),
                        Text(
                          '$wordCount ${AppLocalizations.get('words', settings.language)}',
                          style: GoogleFonts.lato(fontSize: 12, color: subColor),
                        ),
                      ],
                    ),
                    // O'qish vaqti
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 13, color: subColor),
                        const SizedBox(width: 5),
                        Text(
                          '~$readMinutes ${AppLocalizations.get('estimated_minutes', settings.language)}',
                          style: GoogleFonts.lato(fontSize: 12, color: subColor),
                        ),
                      ],
                    ),
                    // O'qish tugmasi
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isRead
                            ? Colors.green.withValues(alpha: 0.15)
                            : accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isRead
                              ? Colors.green.withValues(alpha: 0.4)
                              : accent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        isRead
                            ? AppLocalizations.get('read', settings.language)
                            : AppLocalizations.get(
                                'start_reading', settings.language),
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isRead ? Colors.green : accent,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetDialog(
    BuildContext context,
    ReadingProvider reading,
    SettingsProvider settings,
    bool isDark,
  ) {
    showWaterDropDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF13102A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.get('clear_history', settings.language),
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        content: Text(
          AppLocalizations.get('clear_history_confirm', settings.language),
          style: GoogleFonts.lato(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.get('cancel', settings.language),
                style: GoogleFonts.lato()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (ctx.mounted) {
                Navigator.pop(ctx);
                await reading.init();
                await settings.init();
              }
            },
            child: Text(AppLocalizations.get('clear', settings.language),
                style: GoogleFonts.lato()),
          ),
        ],
      ),
    );
  }
}
