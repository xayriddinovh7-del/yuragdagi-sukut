import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/book_data.dart' as book;
import '../../data/models/bookmark.dart';
import '../../providers/reading_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/glass_decorations.dart';
import '../../core/constants/image_urls.dart';
import '../../widgets/glass_widgets.dart';
import '../../widgets/cinematic_image.dart';
import '../../widgets/settings_drawer.dart';
import '../../widgets/bookmark_panel.dart';

import '../../painters/rain_painter.dart';
import '../../painters/floating_orbs.dart';
import '../../utils/responsive.dart';
import '../../core/constants/translations.dart';

class ReaderScreen extends StatefulWidget {
  final int chapterIndex;
  const ReaderScreen({super.key, required this.chapterIndex});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController _scrollController;
  late int _currentIndex;
  bool _showControls = true;
  double _lastOffset = 0.0;

  // Timers
  Timer? _sessionTimer;
  int _secondsSpent = 0;
  Timer? _autoScrollTimer;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.chapterIndex;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Restore scroll position and set up timers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final savedPos = Provider.of<ReadingProvider>(context, listen: false)
          .getScrollPosition(_currentIndex);
      if (savedPos > 0 && _scrollController.hasClients) {
        _scrollController.jumpTo(savedPos);
      }
      _startSessionTimer();
      _setupAutoScroll();
      _resetControlsTimer();
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _autoScrollTimer?.cancel();
    _controlsTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;

    final offset = _scrollController.offset;

    // Save scroll position
    Provider.of<ReadingProvider>(context, listen: false)
        .saveScrollPosition(_currentIndex, offset);

    // Safari-style smart auto-hiding controls based on scroll direction
    final delta = offset - _lastOffset;
    if (delta > 15 && _showControls && offset > 100) {
      setState(() {
        _showControls = false;
      });
    } else if (delta < -15 && !_showControls) {
      setState(() {
        _showControls = true;
      });
      _resetControlsTimer();
    }
    _lastOffset = offset;
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    if (!_showControls) return;
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted &&
          _scrollController.hasClients &&
          _scrollController.offset > 50) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsSpent++;
      if (_secondsSpent >= 60) {
        Provider.of<ReadingProvider>(context, listen: false).addReadingTime(1);
        _secondsSpent = 0;
      }
    });
  }

  void _setupAutoScroll() {
    _autoScrollTimer?.cancel();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (!settings.autoScroll) return;

    _autoScrollTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || !_scrollController.hasClients) return;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      if (currentScroll >= maxScroll) {
        settings.setAutoScroll(false);
        _autoScrollTimer?.cancel();
        return;
      }

      final speed = settings.autoScrollSpeed;
      _scrollController.jumpTo(currentScroll + (speed * 0.4));
    });
  }

  void _goToChapter(int index) {
    final lang = Provider.of<SettingsProvider>(context, listen: false).language;
    final chapters = book.BookData.getChapters(lang);
    if (index >= 0 && index < chapters.length) {
      setState(() {
        _currentIndex = index;
        _showControls = true;
      });
      Provider.of<ReadingProvider>(context, listen: false)
          .setCurrentChapter(index);

      // Jump to top and restart auto scroll
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      _setupAutoScroll();
      _resetControlsTimer();
    }
  }

  void _nextChapter() {
    final lang = Provider.of<SettingsProvider>(context, listen: false).language;
    if (_currentIndex < book.BookData.getChapters(lang).length - 1) {
      _goToChapter(_currentIndex + 1);
    }
  }

  void _prevChapter() {
    if (_currentIndex > 0) {
      _goToChapter(_currentIndex - 1);
    }
  }

  TextStyle _getReadingStyle(SettingsProvider settings, Color defaultColor,
      {bool isDialogue = false}) {
    final double fs = settings.fontSize;
    final double lh = settings.lineHeight;
    final Color textColor =
        isDialogue ? settings.readingTheme.dialogueColor : defaultColor;
    final FontStyle style = isDialogue ? FontStyle.italic : FontStyle.normal;

    switch (settings.fontFamily) {
      case 'Noto Serif':
        return GoogleFonts.notoSerif(
            fontSize: fs, height: lh, color: textColor, fontStyle: style);
      case 'Playfair Display':
        return GoogleFonts.playfairDisplay(
            fontSize: fs, height: lh, color: textColor, fontStyle: style);
      case 'Roboto':
        return GoogleFonts.roboto(
            fontSize: fs, height: lh, color: textColor, fontStyle: style);
      case 'Lato':
      default:
        return GoogleFonts.lato(
            fontSize: fs, height: lh, color: textColor, fontStyle: style);
    }
  }

  void _showParagraphOptions(
      String text, int paragraphIndex, String chapterTitle) {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final isBookmarked =
        bookmarkProvider.isBookmarked(_currentIndex, paragraphIndex);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final theme = settings.readingTheme;
    final lang = settings.language;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return GlassWidget(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          decoration: GlassDecorations.navBar(isDark: theme.isDark),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.get('paragraph_options', lang),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: theme.textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(
                      isBookmarked
                          ? Icons.bookmark_remove_rounded
                          : Icons.bookmark_add_rounded,
                      color:
                          isBookmarked ? Colors.redAccent : theme.accentColor,
                    ),
                    title: Text(
                      isBookmarked
                          ? AppLocalizations.get('bookmark_remove', lang)
                          : AppLocalizations.get('bookmark_add', lang),
                      style: GoogleFonts.lato(color: theme.textColor),
                    ),
                    onTap: () async {
                      Navigator.pop(ctx);
                      if (isBookmarked) {
                        await bookmarkProvider.removeBookmark(
                            _currentIndex, paragraphIndex);
                        _showSnackBar(
                            AppLocalizations.get('bookmark_removed', lang));
                      } else {
                        final b = Bookmark(
                          chapterIndex: _currentIndex,
                          chapterTitle: chapterTitle,
                          text: text,
                          paragraphIndex: paragraphIndex,
                          savedAt: DateTime.now(),
                        );
                        await bookmarkProvider.addBookmark(b);
                        _showSnackBar(
                            AppLocalizations.get('bookmark_added', lang));
                      }
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.note_add_outlined, color: theme.accentColor),
                    title: Text(
                      AppLocalizations.get('add_note', lang),
                      style: GoogleFonts.lato(color: theme.textColor),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showAddNoteDialog(text, paragraphIndex, chapterTitle);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.copy_rounded, color: theme.accentColor),
                    title: Text(
                      AppLocalizations.get('copy_text', lang),
                      style: GoogleFonts.lato(color: theme.textColor),
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: text));
                      Navigator.pop(ctx);
                      _showSnackBar(
                          AppLocalizations.get('text_copied', lang));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddNoteDialog(
      String text, int paragraphIndex, String chapterTitle) {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final theme = settings.readingTheme;
    final lang = settings.language;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: theme.surfaceColor.withValues(alpha: 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15), width: 1.5),
            ),
            title: Text(
              AppLocalizations.get('add_note_title', lang),
              style: GoogleFonts.playfairDisplay(
                color: theme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: theme.textColor.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  style: TextStyle(color: theme.textColor),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.get('note_hint', lang),
                    hintStyle: TextStyle(
                        color: theme.textColor.withValues(alpha: 0.4)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: theme.accentColor, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppLocalizations.get('cancel', lang),
                    style: TextStyle(
                        color: theme.textColor.withValues(alpha: 0.6))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                  shadowColor: theme.accentColor.withValues(alpha: 0.4),
                ),
                onPressed: () async {
                  final b = Bookmark(
                    chapterIndex: _currentIndex,
                    chapterTitle: chapterTitle,
                    text: text,
                    paragraphIndex: paragraphIndex,
                    savedAt: DateTime.now(),
                    note: noteController.text,
                  );
                  await bookmarkProvider.addBookmark(b);
                  if (ctx.mounted) Navigator.pop(ctx);
                  _showSnackBar(AppLocalizations.get('note_saved', lang));
                },
                child: Text(AppLocalizations.get('save', lang),
                    style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.lato(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF13102A).withValues(alpha: 0.95),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final readingProvider = Provider.of<ReadingProvider>(context);
    final lang = settingsProvider.language;

    final chapters = book.BookData.getChapters(lang);
    final chapter = chapters[_currentIndex.clamp(0, chapters.length - 1)];
    final theme = settingsProvider.readingTheme;
    final accentColor = theme.accentColor;
    final textColor = theme.textColor;

    // Background Image strategy
    final bgUrl =
        theme.isDark ? ImageUrls.readerDarkBg : ImageUrls.readerLightBg;

    // Split text into paragraphs
    final paragraphs = chapter.content
        .split('\n\n')
        .where((p) => p.trim().isNotEmpty)
        .toList();

    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final bool isDesktop = screenWidth >= 1200;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.bgColor,
      endDrawer: SettingsDrawer(
        onChanged: () {
          _setupAutoScroll();
        },
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
          if (_showControls) {
            _resetControlsTimer();
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < -300) {
            _nextChapter();
          } else if (details.primaryVelocity! > 300) {
            _prevChapter();
          }
        },
        child: Stack(
          children: [
            // 1. Full-Screen Parallax Background Image
            AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                double scrollOffset = 0.0;
                if (_scrollController.hasClients) {
                  scrollOffset = _scrollController.offset;
                }
                double bgTranslateY = -scrollOffset * 0.15;
                return Positioned.fill(
                  top: bgTranslateY,
                  bottom: -180,
                  child: Transform.scale(
                    scale: 1.12,
                    child: Image.asset(
                      bgUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const ColoredBox(color: Color(0xFF0D0A1A)),
                    ),
                  ),
                );
              },
            ),

            // 2. Solid Color & Ambient Tint Layer (layered, never flat)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.bgColor.withValues(alpha: 0.82),
                      theme.bgColor.withValues(alpha: 0.88),
                      theme.bgColor,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // 3. Floating Ambient Glow Orbs (Visual depth)
            const Positioned.fill(
              child: IgnorePointer(
                child: FloatingOrbs(),
              ),
            ),

            // 4. Rain Custom Painter Overlay running in background
            Positioned.fill(
              child: IgnorePointer(
                child: RainAnimation(
                  isDark: theme.isDark,
                  enabled: true,
                ),
              ),
            ),

            // 5. Main Scrolling Layout & Desktop Split Screen
            Positioned.fill(
              child: Row(
                children: [
                  // Desktop Sidebar (>=1200px)
                  if (isDesktop)
                    _Sidebar(
                      currentChapterIndex: _currentIndex,
                      readChapters: readingProvider.readChapters,
                      overallProgress: readingProvider.progress,
                      progressText: readingProvider.progressText(lang),
                      onChapterSelected: (idx) => _goToChapter(idx),
                      accentColor: accentColor,
                      theme: theme,
                    ),

                  // Reading Cards Viewport
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    settingsProvider.readingWidth.maxWidth,
                              ),
                              child: GlassCard(
                                margin: EdgeInsets.only(
                                  top: mediaQuery.padding.top + 88,
                                  bottom: mediaQuery.padding.bottom + 120,
                                  left: 20,
                                  right: 20,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 48),
                                glowColor: accentColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Cinematic Chapter Header
                                    _buildChapterHeader(
                                        chapter, theme, accentColor),
                                    const SizedBox(height: 48),

                                    // Chapter Content Paragraphs
                                    ...List.generate(paragraphs.length, (idx) {
                                      final para = paragraphs[idx].trim();
                                      final isDialogue = para.startsWith('—') ||
                                          para.startsWith('–') ||
                                          para.startsWith('"') ||
                                          para.startsWith('«') ||
                                          para.startsWith('-');

                                      final isBookmarked = bookmarkProvider
                                          .isBookmarked(_currentIndex, idx);

                                      return GestureDetector(
                                        onLongPress: () =>
                                            _showParagraphOptions(
                                                para, idx, chapter.title),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          margin:
                                              const EdgeInsets.only(bottom: 6),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: isBookmarked
                                                ? accentColor.withValues(
                                                    alpha: 0.08)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isBookmarked
                                                  ? accentColor.withValues(
                                                      alpha: 0.15)
                                                  : Colors.transparent,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (isBookmarked)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0, top: 6.0),
                                                  child: Icon(
                                                      Icons.bookmark_rounded,
                                                      color: accentColor,
                                                      size: 15),
                                                ),
                                              Expanded(
                                                child: _buildParagraphWidget(
                                                  para,
                                                  idx,
                                                  settingsProvider,
                                                  textColor,
                                                  accentColor,
                                                  isDialogue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),

                                    // Bottom flourishes
                                    _buildEndFlourish(context, _currentIndex,
                                        accentColor, theme),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 6. Frosted Glass Top Nav Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedSlide(
                offset: _showControls ? Offset.zero : const Offset(0, -1.2),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: GlassWidget(
                  borderRadius: BorderRadius.zero,
                  decoration: GlassDecorations.navBar(isDark: theme.isDark),
                  child: Container(
                    height: 64 + mediaQuery.padding.top,
                    padding: EdgeInsets.only(top: mediaQuery.padding.top),
                    child: Stack(
                      children: [
                        // Thin reading progress indicator at the very top
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedBuilder(
                            animation: _scrollController,
                            builder: (context, _) {
                              double scrollProg = 0.0;
                              if (_scrollController.hasClients &&
                                  _scrollController.position.maxScrollExtent >
                                      0) {
                                scrollProg = _scrollController.offset /
                                    _scrollController.position.maxScrollExtent;
                              }
                              return Container(
                                height: 3,
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: scrollProg.clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          accentColor,
                                          accentColor.withValues(alpha: 0.4),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Back title and controls
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            GlassPillIconButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              tooltip: AppLocalizations.get('back', lang),
                              onTap: () => context.go('/home'),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                chapter.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textColor,
                                ),
                              ),
                            ),
                            GlassPillIconButton(
                              icon: theme.icon,
                              tooltip: AppLocalizations.get('theme_change', lang),
                              onTap: () => settingsProvider.cycleTheme(),
                            ),
                            const SizedBox(width: 8),
                            GlassPillIconButton(
                              icon: Icons.bookmarks_rounded,
                              tooltip: AppLocalizations.get('bookmarks_list', lang),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (_) => BookmarkPanel(
                                    onNavigate: (chapIdx, paraIdx) {
                                      _goToChapter(chapIdx);
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            GlassPillIconButton(
                              icon: Icons.text_fields_rounded,
                              tooltip: AppLocalizations.get('reader_settings', lang),
                              onTap: () {
                                _scaffoldKey.currentState?.openEndDrawer();
                              },
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 7. Frosted Glass Bottom Page Nav Pill
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: AnimatedSlide(
                offset: _showControls ? Offset.zero : const Offset(0, 1.8),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: Center(
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: GlassWidget(
                      borderRadius: BorderRadius.circular(50),
                      decoration: GlassDecorations.darkCard(
                        radius: 50,
                        bgOpacity: 0.12,
                        glowColor: accentColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GlassPillIconButton(
                              icon: Icons.chevron_left_rounded,
                              color: _currentIndex > 0
                                  ? theme.textColor
                                  : theme.textColor.withValues(alpha: 0.25),
                              onTap: _currentIndex > 0 ? _prevChapter : null,
                            ),
                            const SizedBox(width: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: accentColor.withValues(alpha: 0.2)),
                              ),
                              child: Text(
                                '${AppLocalizations.get('chapter_label', lang)} ${_currentIndex + 1} / ${chapters.length}',
                                style: GoogleFonts.montserrat(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            GlassPillIconButton(
                              icon: Icons.chevron_right_rounded,
                              color: _currentIndex < chapters.length - 1
                                  ? theme.textColor
                                  : theme.textColor.withValues(alpha: 0.25),
                              onTap: _currentIndex < chapters.length - 1
                                  ? _nextChapter
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header builder ─────────────────────────────────────────────────────────────
  Widget _buildChapterHeader(
      book.Chapter chapter, ReadingTheme theme, Color accentColor) {
    final r = Responsive.of(context);
    final lang =
        Provider.of<SettingsProvider>(context, listen: false).language;
    return Column(
      children: [
        // Mood image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CinematicImage(
            url: ImageUrls.chapterImage(chapter.index),
            height: r.readerHeaderHeight,
            bgColor: theme.surfaceColor.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),

        // Chapter label
        Text(
          '${AppLocalizations.get('chapter_label', lang)} ${chapter.index + 1}',
          style: GoogleFonts.lato(
            letterSpacing: 6,
            fontSize: 11,
            color: accentColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),

        // Chapter title
        Text(
          chapter.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: theme.textColor,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 24),

        // Decorative divider with central symbol ✦
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlowLine(width: 60, color: accentColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                '✦',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFF59E0B),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GlowLine(width: 60, color: accentColor),
          ],
        ),
        const SizedBox(height: 10),

        // Estimated reading time
        Text(
          '~${(chapter.content.length / 900).ceil()} ${AppLocalizations.get('estimated_read', lang)}',
          style: GoogleFonts.lato(
            color: theme.textColor.withValues(alpha: 0.4),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ─── Paragraph Render Logic ───────────────────────────────────────────────────
  Widget _buildParagraphWidget(
    String text,
    int index,
    SettingsProvider settings,
    Color defaultColor,
    Color accentColor,
    bool isDialogue,
  ) {
    final textStyle =
        _getReadingStyle(settings, defaultColor, isDialogue: isDialogue);

    // Drop Cap for the very first paragraph in the chapter
    if (index == 0 && text.isNotEmpty) {
      final firstLetter = text[0];
      final rest = text.substring(1);
      return Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, bottom: 4),
                  child: Text(
                    firstLetter,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 72,
                      height: 0.85,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextSpan(
                text: rest,
                style: textStyle,
              ),
            ],
          ),
        ),
      );
    }

    // High fidelity Dialogue Paragraph (Italicized with left border accent)
    if (isDialogue) {
      return Container(
        margin: const EdgeInsets.only(left: 20, bottom: 22, top: 4),
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: accentColor.withValues(alpha: 0.5),
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: textStyle,
        ),
      );
    }

    // Normal paragraph
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: textStyle,
      ),
    );
  }

  // ─── Chapter flourish and next chapter teaser ──────────────────────────────────
  Widget _buildEndFlourish(BuildContext context, int currentChapterIndex,
      Color accentColor, ReadingTheme theme) {
    final lang =
        Provider.of<SettingsProvider>(context, listen: false).language;
    final localChapters = book.BookData.getChapters(lang);
    final nextIndex = currentChapterIndex + 1;
    final hasNext = nextIndex < localChapters.length;
    final nextChapter = hasNext ? localChapters[nextIndex] : null;

    return Column(
      children: [
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlowLine(width: 40, color: accentColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '❧',
                style: GoogleFonts.playfairDisplay(
                  color: const Color(0xFFF59E0B),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GlowLine(width: 40, color: accentColor),
          ],
        ),
        const SizedBox(height: 32),
        if (hasNext && nextChapter != null) ...[
          GestureDetector(
            onTap: () => _goToChapter(nextIndex),
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              glowColor: accentColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.get('next_chapter_label', lang),
                    style: GoogleFonts.lato(
                      letterSpacing: 4,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.get('chapter', lang)} ${nextIndex + 1}: ${nextChapter.title}',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nextChapter.content.split('\n\n').first,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      height: 1.5,
                      color: theme.textColor.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.get('continue_next', lang),
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded,
                          color: accentColor, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          // Final book end indicator
          GlassCard(
            padding: const EdgeInsets.all(32),
            glowColor: accentColor,
            child: Column(
              children: [
                Text(
                  AppLocalizations.get('book_finished', lang),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.get('book_finished_text', lang),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    height: 1.5,
                    color: theme.textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Desktop Sidebar Widget ───────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final int currentChapterIndex;
  final Set<int> readChapters;
  final double overallProgress;
  final String progressText;
  final ValueChanged<int> onChapterSelected;
  final Color accentColor;
  final ReadingTheme theme;

  const _Sidebar({
    required this.currentChapterIndex,
    required this.readChapters,
    required this.overallProgress,
    required this.progressText,
    required this.onChapterSelected,
    required this.accentColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final lang =
        Provider.of<SettingsProvider>(context, listen: false).language;
    final localChapters = book.BookData.getChapters(lang);
    return Container(
      width: r.readerSidebarWidth,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border(
          right: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Column(
            children: [
              // Book Cover and metadata
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Book cover
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 170,
                        width: 110,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.45),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          ImageUrls.bookCover,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const ColoredBox(color: Color(0xFF13102A)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      book.BookData.getTitle(lang),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.BookData.getAuthor(lang),
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: theme.textColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white12, height: 1),

              // Circle progress indicator
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CircularProgressIndicator(
                              value: overallProgress,
                              strokeWidth: 3.5,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation(accentColor),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${(overallProgress * 100).toInt()}%',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: theme.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.get('reading_progress', lang),
                            style: GoogleFonts.lato(
                              fontSize: 11,
                              color: theme.textColor.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            progressText,
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: theme.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white12, height: 1),

              // Interactive Chapter List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: localChapters.length,
                  itemBuilder: (context, idx) {
                    final ch = localChapters[idx];
                    final isCurrent = idx == currentChapterIndex;
                    final isRead = readChapters.contains(idx);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onChapterSelected(idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          color: isCurrent
                              ? accentColor.withValues(alpha: 0.12)
                              : Colors.transparent,
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCurrent
                                      ? accentColor
                                      : (isRead
                                          ? accentColor.withValues(alpha: 0.18)
                                          : Colors.white
                                              .withValues(alpha: 0.05)),
                                  border: Border.all(
                                    color: isCurrent || isRead
                                        ? Colors.transparent
                                        : Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Center(
                                  child: isCurrent
                                      ? Icon(Icons.menu_book_rounded,
                                          size: 11,
                                          color: theme.isDark
                                              ? Colors.white
                                              : Colors.black)
                                      : (isRead
                                          ? Icon(Icons.check,
                                              size: 11, color: accentColor)
                                          : Text(
                                              '${idx + 1}',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: theme.textColor
                                                    .withValues(alpha: 0.4),
                                              ),
                                            )),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  ch.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 14,
                                    fontWeight: isCurrent
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isCurrent
                                        ? accentColor
                                        : theme.textColor
                                            .withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
