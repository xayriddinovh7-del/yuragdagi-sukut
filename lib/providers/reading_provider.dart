import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingProvider extends ChangeNotifier {
  int _currentChapter = 0;
  Set<int> _readChapters = {};
  final Map<int, double> _scrollPositions = {};
  int _totalReadingMinutes = 0;
  bool _splashDone = false;
  bool _readingModeActive = false;

  int get currentChapter => _currentChapter;
  Set<int> get readChapters => _readChapters;
  int get totalReadingMinutes => _totalReadingMinutes;
  bool get splashDone => _splashDone;
  bool get readingModeActive => _readingModeActive;

  double get progress {
    const total = 9;
    if (_readChapters.isEmpty) return 0;
    return _readChapters.length / total;
  }

  String get progressText {
    final pct = (progress * 100).toInt();
    if (pct == 0) return 'Boshlanmagan';
    if (pct >= 100) return 'Tugallangan ✓';
    return '$pct% o\'qilgan';
  }

  double getScrollPosition(int chapterIndex) =>
      _scrollPositions[chapterIndex] ?? 0.0;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentChapter = prefs.getInt('rp_currentChapter') ?? 0;
    _totalReadingMinutes = prefs.getInt('rp_totalMinutes') ?? 0;
    _splashDone = prefs.getBool('rp_splashDone') ?? false;

    final readList = prefs.getStringList('rp_readChapters') ?? [];
    _readChapters = readList.map((e) => int.tryParse(e) ?? 0).toSet();

    final posKeys = prefs.getStringList('rp_scrollKeys') ?? [];
    for (final key in posKeys) {
      final val = prefs.getDouble('rp_scroll_$key');
      if (val != null) _scrollPositions[int.tryParse(key) ?? 0] = val;
    }

    notifyListeners();
  }

  Future<void> setCurrentChapter(int index) async {
    _currentChapter = index;
    _readChapters.add(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rp_currentChapter', index);
    await prefs.setStringList(
        'rp_readChapters', _readChapters.map((e) => e.toString()).toList());
    notifyListeners();
  }

  Future<void> saveScrollPosition(int chapterIndex, double position) async {
    _scrollPositions[chapterIndex] = position;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('rp_scroll_$chapterIndex', position);
    final keys = _scrollPositions.keys.map((k) => k.toString()).toList();
    await prefs.setStringList('rp_scrollKeys', keys);
  }

  Future<void> markSplashDone() async {
    _splashDone = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rp_splashDone', true);
    notifyListeners();
  }

  Future<void> addReadingTime(int minutes) async {
    _totalReadingMinutes += minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rp_totalMinutes', _totalReadingMinutes);
    notifyListeners();
  }

  void toggleReadingMode() {
    _readingModeActive = !_readingModeActive;
    notifyListeners();
  }

  void setReadingMode(bool active) {
    _readingModeActive = active;
    notifyListeners();
  }

  bool isChapterRead(int index) => _readChapters.contains(index);

  String get readingTimeText {
    if (_totalReadingMinutes < 60) return '$_totalReadingMinutes daqiqa';
    final h = _totalReadingMinutes ~/ 60;
    final m = _totalReadingMinutes % 60;
    return '${h}s ${m}d';
  }
}