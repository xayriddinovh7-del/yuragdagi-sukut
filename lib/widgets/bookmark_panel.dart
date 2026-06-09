import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../providers/bookmark_provider.dart';
import '../providers/reading_provider.dart';
import '../providers/settings_provider.dart';
import '../core/constants/translations.dart';

class BookmarkPanel extends StatelessWidget {
  final Function(int chapterIndex, int paragraphIndex)? onNavigate;

  const BookmarkPanel({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BookmarkProvider, ReadingProvider>(
      builder: (ctx, bookmarkProv, readingProv, _) {
        return Consumer<SettingsProvider>(
          builder: (ctx2, settings, _) {
            final theme = settings.readingTheme;
            final bg = theme.surfaceColor;
            final textColor = theme.textColor;
            final subColor = theme.subTextColor;
            final accent = theme.accentColor;
            final isDark = theme.isDark;
            final lang = settings.language;

            final bookmarks = bookmarkProv.bookmarks;

            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.65)
                        : bg.withValues(alpha: 0.94),
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.10)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(top: 12, bottom: 12),
                          decoration: BoxDecoration(
                            color: subColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Title row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.bookmarks_rounded, color: accent, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.get('bookmarks_list', lang),
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${bookmarks.length} ${AppLocalizations.get('bookmarks_count', lang)}',
                              style: GoogleFonts.lato(fontSize: 12, color: subColor),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      Expanded(
                        child: bookmarks.isEmpty
                            ? _buildEmptyState(subColor, lang)
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                itemCount: bookmarks.length,
                                itemBuilder: (context, index) {
                                  final bm = bookmarks[index];
                                  return _buildBookmarkCard(
                                    context,
                                    bm,
                                    textColor,
                                    subColor,
                                    accent,
                                    isDark,
                                    bookmarkProv,
                                    lang,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(Color subColor, String lang) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 64, color: subColor.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.get('no_bookmarks_title', lang),
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: subColor.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.get('no_bookmarks_sub', lang),
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 13,
              color: subColor.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context,
    dynamic bm,
    Color textColor,
    Color subColor,
    Color accent,
    bool isDark,
    BookmarkProvider prov,
    String lang,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pop(context);
            onNavigate?.call(bm.chapterIndex, bm.paragraphIndex);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${AppLocalizations.get('chapter_badge', lang)} ${bm.chapterIndex + 1}',
                        style: GoogleFonts.lato(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bm.chapterTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      color: Colors.red.withValues(alpha: 0.7),
                      onPressed: () {
                        prov.removeBookmark(bm.chapterIndex, bm.paragraphIndex);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  bm.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerif(
                    fontSize: 13,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
                if (bm.note != null && bm.note!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.sticky_note_2_outlined, size: 14, color: accent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          bm.note!,
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: accent.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(bm.savedAt),
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: subColor.withValues(alpha: 0.7),
                      ),
                    ),
                    // Note edit button
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => _showNoteDialog(context, bm, prov, textColor, isDark, lang),
                      icon: Icon(Icons.mode_edit_outline_outlined, size: 12, color: subColor),
                      label: Text(
                        bm.note == null
                            ? AppLocalizations.get('add_note_short', lang)
                            : AppLocalizations.get('edit_note', lang),
                        style: GoogleFonts.lato(fontSize: 11, color: subColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _showNoteDialog(
    BuildContext context,
    dynamic bm,
    BookmarkProvider prov,
    Color textColor,
    bool isDark,
    String lang,
  ) {
    final controller = TextEditingController(text: bm.note ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: isDark ? const Color(0xFF13102A) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              AppLocalizations.get('note_dialog_title', lang),
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            content: TextField(
              controller: controller,
              maxLines: 3,
              style: GoogleFonts.lato(color: textColor),
              decoration: InputDecoration(
                hintText: AppLocalizations.get('note_dialog_hint', lang),
                hintStyle: GoogleFonts.lato(color: textColor.withValues(alpha: 0.4)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: isDark ? const Color(0xFF9B59B6) : const Color(0xFF7C3AED)),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  AppLocalizations.get('cancel', lang),
                  style: GoogleFonts.lato(color: textColor.withValues(alpha: 0.7)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF9B59B6) : const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  prov.addBookmark(bm.copyWith(note: controller.text));
                  Navigator.pop(ctx);
                },
                child: Text(
                  AppLocalizations.get('save', lang),
                  style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
