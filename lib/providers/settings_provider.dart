import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import '../data/models/reading_settings.dart';

class SettingsProvider extends ChangeNotifier {
  ReadingSettings _settings = const ReadingSettings();
  bool _initialized = false;

  ReadingSettings get settings => _settings;
  bool get initialized => _initialized;

  // Convenience getters
  ReadingTheme get readingTheme => _settings.readingTheme;
  double get fontSize => _settings.fontSize;
  double get lineHeight => _settings.lineHeight;
  String get fontFamily => _settings.fontFamily;
  ReadingWidth get readingWidth => _settings.readingWidth;
  bool get autoScroll => _settings.autoScroll;
  double get autoScrollSpeed => _settings.autoScrollSpeed;
  bool get showReadingProgress => _settings.showReadingProgress;
  bool get enableTextSelection => _settings.enableTextSelection;
  bool get isDark => _settings.readingTheme == ReadingTheme.dark;
  String get language => _settings.language;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final themeIndex = prefs.getInt('v2_readingTheme') ?? 0;
    final widthIndex = prefs.getInt('v2_readingWidth') ?? 1;

    _settings = ReadingSettings(
      fontSize: prefs.getDouble('v2_fontSize') ?? 18.0,
      lineHeight: prefs.getDouble('v2_lineHeight') ?? 1.8,
      fontFamily: prefs.getString('v2_fontFamily') ?? 'Noto Serif',
      readingTheme: ReadingTheme.values[themeIndex.clamp(0, ReadingTheme.values.length - 1)],
      readingWidth: ReadingWidth.values[widthIndex.clamp(0, ReadingWidth.values.length - 1)],
      autoScroll: prefs.getBool('v2_autoScroll') ?? false,
      autoScrollSpeed: prefs.getDouble('v2_autoScrollSpeed') ?? 1.0,
      showReadingProgress: prefs.getBool('v2_showProgress') ?? true,
      enableTextSelection: prefs.getBool('v2_textSelection') ?? true,
      language: prefs.getString('v2_language') ?? 'uz',
    );

    _initialized = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('v2_fontSize', _settings.fontSize);
    await prefs.setDouble('v2_lineHeight', _settings.lineHeight);
    await prefs.setString('v2_fontFamily', _settings.fontFamily);
    await prefs.setInt('v2_readingTheme', _settings.readingTheme.index);
    await prefs.setInt('v2_readingWidth', _settings.readingWidth.index);
    await prefs.setBool('v2_autoScroll', _settings.autoScroll);
    await prefs.setDouble('v2_autoScrollSpeed', _settings.autoScrollSpeed);
    await prefs.setBool('v2_showProgress', _settings.showReadingProgress);
    await prefs.setBool('v2_textSelection', _settings.enableTextSelection);
    await prefs.setString('v2_language', _settings.language);
  }

  void _update(ReadingSettings updated) {
    _settings = updated;
    notifyListeners();
    _save();
  }

  void setFontSize(double size) =>
      _update(_settings.copyWith(fontSize: size.clamp(12.0, 32.0)));

  void setLineHeight(double height) =>
      _update(_settings.copyWith(lineHeight: height));

  void setFontFamily(String family) =>
      _update(_settings.copyWith(fontFamily: family));

  void setReadingTheme(ReadingTheme theme) =>
      _update(_settings.copyWith(readingTheme: theme));

  void cycleTheme() {
    final next = ReadingTheme.values[
        (_settings.readingTheme.index + 1) % ReadingTheme.values.length];
    setReadingTheme(next);
  }

  void setReadingWidth(ReadingWidth width) =>
      _update(_settings.copyWith(readingWidth: width));

  void setAutoScroll(bool value) =>
      _update(_settings.copyWith(autoScroll: value));

  void setAutoScrollSpeed(double speed) =>
      _update(_settings.copyWith(autoScrollSpeed: speed.clamp(0.2, 5.0)));

  void setShowReadingProgress(bool value) =>
      _update(_settings.copyWith(showReadingProgress: value));

  void setEnableTextSelection(bool value) =>
      _update(_settings.copyWith(enableTextSelection: value));

  void setLanguage(String lang) =>
      _update(_settings.copyWith(language: lang));

  void resetDefaults() => _update(const ReadingSettings());
}