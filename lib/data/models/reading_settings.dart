import '../../core/theme/app_colors.dart';

// ─── Reading Settings Model ────────────────────────────────────────────────────
class ReadingSettings {
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final ReadingTheme readingTheme;
  final ReadingWidth readingWidth;
  final bool autoScroll;
  final double autoScrollSpeed;
  final bool showReadingProgress;
  final bool enableTextSelection;
  final String language;

  const ReadingSettings({
    this.fontSize = 18.0,
    this.lineHeight = 1.8,
    this.fontFamily = 'Noto Serif',
    this.readingTheme = ReadingTheme.dark,
    this.readingWidth = ReadingWidth.normal,
    this.autoScroll = false,
    this.autoScrollSpeed = 1.0,
    this.showReadingProgress = true,
    this.enableTextSelection = true,
    this.language = 'uz',
  });

  ReadingSettings copyWith({
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    ReadingTheme? readingTheme,
    ReadingWidth? readingWidth,
    bool? autoScroll,
    double? autoScrollSpeed,
    bool? showReadingProgress,
    bool? enableTextSelection,
    String? language,
  }) =>
      ReadingSettings(
        fontSize: fontSize ?? this.fontSize,
        lineHeight: lineHeight ?? this.lineHeight,
        fontFamily: fontFamily ?? this.fontFamily,
        readingTheme: readingTheme ?? this.readingTheme,
        readingWidth: readingWidth ?? this.readingWidth,
        autoScroll: autoScroll ?? this.autoScroll,
        autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
        showReadingProgress: showReadingProgress ?? this.showReadingProgress,
        enableTextSelection: enableTextSelection ?? this.enableTextSelection,
        language: language ?? this.language,
      );
}

enum ReadingWidth {
  narrow(640.0, 'Tor'),
  normal(720.0, 'Normal'),
  wide(900.0, 'Keng');

  final double maxWidth;
  final String label;
  const ReadingWidth(this.maxWidth, this.label);
}
