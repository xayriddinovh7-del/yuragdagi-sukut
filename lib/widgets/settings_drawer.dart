import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../data/models/reading_settings.dart';
import '../providers/settings_provider.dart';
import '../core/constants/translations.dart';
import 'glass_widgets.dart';
import '../utils/responsive.dart';

class SettingsDrawer extends StatelessWidget {
  final VoidCallback? onChanged;
  const SettingsDrawer({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (ctx, settings, _) {
        final theme = settings.readingTheme;
        final bg = theme.surfaceColor;
        final textColor = theme.textColor;
        final subColor = theme.subTextColor;
        final accent = theme.accentColor;
        final isDark = theme.isDark;

        return Material(
          color: Colors.transparent,
          child: Builder(
            builder: (context) {
              final r = Responsive.of(context);
              final isFullScreen = r.isCompact || r.isMobile;
              final drawerWidth = isFullScreen
                  ? MediaQuery.sizeOf(context).width
                  : r.settingsDrawerWidth;
              return ClipRRect(
                borderRadius: isFullScreen
                    ? const BorderRadius.vertical(top: Radius.circular(28))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        bottomLeft: Radius.circular(28),
                      ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    width: drawerWidth,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.55)
                          : bg.withValues(alpha: 0.92),
                      border: Border(
                        left: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.10)
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                Icon(Icons.tune_rounded,
                                    color: accent, size: 22),
                                const SizedBox(width: 10),
                                Text(
                                  AppLocalizations.get(
                                      'settings', settings.language),
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // Language Selector
                            _sectionLabel(
                                AppLocalizations.get(
                                    'language', settings.language),
                                subColor),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _langPill('uz', "O'zbek", settings, accent,
                                    onChanged),
                                _langPill('ru', 'Русский', settings, accent,
                                    onChanged),
                                _langPill('en', 'English', settings, accent,
                                    onChanged),
                              ],
                            ),

                            const SizedBox(height: 24),
                            _sectionLabel(
                                AppLocalizations.get(
                                    'theme', settings.language),
                                subColor),
                            const SizedBox(height: 10),
                            // Theme pills
                            Row(
                              children: ReadingTheme.values.map((t) {
                                final isSel = settings.readingTheme == t;
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    child: GlassButton(
                                      label: _themeLabel(t, settings.language),
                                      icon: t.icon,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 10),
                                      selected: isSel,
                                      accentColor: accent,
                                      onTap: () {
                                        settings.setReadingTheme(t);
                                        onChanged?.call();
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 24),
                            _sectionLabel(
                                AppLocalizations.get(
                                    'font_size', settings.language),
                                subColor),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _iconBtn(
                                  icon: Icons.text_decrease_rounded,
                                  color: textColor,
                                  onTap: () {
                                    settings.setFontSize(settings.fontSize - 1);
                                    onChanged?.call();
                                  },
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: accent,
                                      inactiveTrackColor:
                                          accent.withValues(alpha: 0.18),
                                      thumbColor: accent,
                                      overlayColor:
                                          accent.withValues(alpha: 0.12),
                                      trackHeight: 3,
                                    ),
                                    child: Slider(
                                      value:
                                          settings.fontSize.clamp(12.0, 32.0),
                                      min: 12,
                                      max: 32,
                                      onChanged: (v) {
                                        settings.setFontSize(v);
                                        onChanged?.call();
                                      },
                                    ),
                                  ),
                                ),
                                _iconBtn(
                                  icon: Icons.text_increase_rounded,
                                  color: textColor,
                                  onTap: () {
                                    settings.setFontSize(settings.fontSize + 1);
                                    onChanged?.call();
                                  },
                                ),
                              ],
                            ),
                            Center(
                              child: Text(
                                '${settings.fontSize.toInt()} px',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: subColor,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            _sectionLabel(
                                AppLocalizations.get(
                                    'font_family', settings.language),
                                subColor),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                'Noto Serif',
                                'Playfair Display',
                                'Lato',
                                'Roboto',
                              ].map((f) {
                                return GlassButton(
                                  label: f,
                                  selected: settings.fontFamily == f,
                                  accentColor: accent,
                                  fontSize: 12,
                                  onTap: () {
                                    settings.setFontFamily(f);
                                    onChanged?.call();
                                  },
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 20),
                            _sectionLabel(
                                AppLocalizations.get(
                                    'line_height', settings.language),
                                subColor),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _lhPill(
                                    1.5,
                                    AppLocalizations.get(
                                        'lh_compact', settings.language),
                                    settings,
                                    accent,
                                    onChanged),
                                const SizedBox(width: 8),
                                _lhPill(
                                    1.8,
                                    AppLocalizations.get(
                                        'lh_normal', settings.language),
                                    settings,
                                    accent,
                                    onChanged),
                                const SizedBox(width: 8),
                                _lhPill(
                                    2.2,
                                    AppLocalizations.get(
                                        'lh_wide', settings.language),
                                    settings,
                                    accent,
                                    onChanged),
                              ],
                            ),

                            const SizedBox(height: 20),
                            _sectionLabel(
                                AppLocalizations.get(
                                    'page_width', settings.language),
                                subColor),
                            const SizedBox(height: 10),
                            Row(
                              children: ReadingWidth.values.map((w) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    child: GlassButton(
                                      label: _widthLabel(w, settings.language),
                                      selected: settings.readingWidth == w,
                                      accentColor: accent,
                                      onTap: () {
                                        settings.setReadingWidth(w);
                                        onChanged?.call();
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 20),
                            _divider(subColor),
                            const SizedBox(height: 16),
                            _sectionLabel(
                                AppLocalizations.get(
                                    'auto_scroll', settings.language),
                                subColor),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.get(
                                      'hands_free', settings.language),
                                  style: GoogleFonts.lato(
                                      fontSize: 13, color: textColor),
                                ),
                                Switch(
                                  value: settings.autoScroll,
                                  activeThumbColor: accent,
                                  onChanged: (v) {
                                    settings.setAutoScroll(v);
                                    onChanged?.call();
                                  },
                                ),
                              ],
                            ),

                            if (settings.autoScroll) ...[
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      AppLocalizations.get(
                                          'speed', settings.language),
                                      style: GoogleFonts.lato(
                                          fontSize: 12, color: subColor)),
                                  Text(
                                    '${settings.autoScrollSpeed.toStringAsFixed(1)}x',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: accent,
                                    ),
                                  ),
                                ],
                              ),
                              SliderTheme(
                                data: SliderThemeData(
                                  activeTrackColor: accent,
                                  inactiveTrackColor:
                                      accent.withValues(alpha: 0.15),
                                  thumbColor: accent,
                                  overlayColor: accent.withValues(alpha: 0.12),
                                  trackHeight: 3,
                                ),
                                child: Slider(
                                  value: settings.autoScrollSpeed,
                                  min: 0.2,
                                  max: 5.0,
                                  onChanged: (v) {
                                    settings.setAutoScrollSpeed(v);
                                    onChanged?.call();
                                  },
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),
                            _divider(subColor),
                            const SizedBox(height: 16),

                            // Reset button
                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  settings.resetDefaults();
                                  onChanged?.call();
                                },
                                icon: Icon(Icons.refresh_rounded,
                                    color: subColor, size: 16),
                                label: Text(
                                  AppLocalizations.get(
                                      'reset', settings.language),
                                  style: GoogleFonts.lato(
                                      fontSize: 13, color: subColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String label, Color color) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.lato(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: color,
      ),
    );
  }

  Widget _divider(Color color) {
    return Divider(color: color.withValues(alpha: 0.3), height: 1);
  }

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 20),
    );
  }

  Widget _lhPill(
    double lh,
    String label,
    SettingsProvider s,
    Color accent,
    VoidCallback? onChanged,
  ) {
    return Expanded(
      child: GlassButton(
        label: label,
        selected: (s.lineHeight - lh).abs() < 0.05,
        accentColor: accent,
        fontSize: 12,
        onTap: () {
          s.setLineHeight(lh);
          onChanged?.call();
        },
      ),
    );
  }

  Widget _langPill(
    String lang,
    String label,
    SettingsProvider s,
    Color accent,
    VoidCallback? onChanged,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GlassButton(
          label: label,
          selected: s.language == lang,
          accentColor: accent,
          fontSize: 12,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          onTap: () {
            s.setLanguage(lang);
            onChanged?.call();
          },
        ),
      ),
    );
  }

  String _themeLabel(ReadingTheme t, String lang) {
    switch (t) {
      case ReadingTheme.dark:
        return AppLocalizations.get('theme_dark', lang);
      case ReadingTheme.light:
        return AppLocalizations.get('theme_light', lang);
      case ReadingTheme.sepia:
        return AppLocalizations.get('theme_sepia', lang);
    }
  }

  String _widthLabel(ReadingWidth w, String lang) {
    switch (w) {
      case ReadingWidth.narrow:
        return AppLocalizations.get('width_narrow', lang);
      case ReadingWidth.normal:
        return AppLocalizations.get('width_normal', lang);
      case ReadingWidth.wide:
        return AppLocalizations.get('width_wide', lang);
    }
  }
}
