import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/sync_service.dart';

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

  // ─── Init: Local → merge Cloud ───────────────────────────────────────────────
  Future<void> init() async {
    // 1. Avval localdan yuklash (tezkor)
    await _loadFromLocal();

    // 2. Keyin clouddan yuklash (agar mavjud bo'lsa)
    await _mergeFromCloud();
  }

  Future<void> _loadFromLocal() async {
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

  /// Cloud ma'lumotlarini lokal bilan birlashtirish.
  /// Cloud yangroq bo'lsa — cloud ma'lumoti ishlatiladi.
  Future<void> _mergeFromCloud() async {
    try {
      final cloudData = await SyncService.loadProgressFromCloud();
      if (cloudData == null) return;

      bool changed = false;

      // O'qilgan boblar: ikkalasini birlashtirish
      final cloudChapters =
          (cloudData['readChapters'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toSet() ??
              {};
      if (cloudChapters.isNotEmpty &&
          !cloudChapters.every(_readChapters.contains)) {
        _readChapters = {..._readChapters, ...cloudChapters};
        changed = true;
      }

      // Joriy bob: cloud yangroq bo'lsa
      final cloudChapter = cloudData['currentChapter'] as int? ?? 0;
      if (cloudChapter > _currentChapter) {
        _currentChapter = cloudChapter;
        changed = true;
      }

      // O'qish vaqti: kattasini olish
      final cloudMinutes = cloudData['totalReadingMinutes'] as int? ?? 0;
      if (cloudMinutes > _totalReadingMinutes) {
        _totalReadingMinutes = cloudMinutes;
        changed = true;
      }

      // Scroll pozitsiyalar: birlashtirish
      final cloudScrollRaw =
          cloudData['scrollPositions'] as Map<String, dynamic>? ?? {};
      for (final entry in cloudScrollRaw.entries) {
        final key = int.tryParse(entry.key) ?? 0;
        final val = (entry.value as num?)?.toDouble() ?? 0.0;
        if (!_scrollPositions.containsKey(key)) {
          _scrollPositions[key] = val;
          changed = true;
        }
      }

      if (changed) {
        await _saveToLocal();
        notifyListeners();
        debugPrint('✅ ReadingProvider: Merged from cloud');
      }
    } catch (e) {
      debugPrint('ℹ️ ReadingProvider: Cloud merge skipped — $e');
    }
  }

  // ─── Local save ──────────────────────────────────────────────────────────────
  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rp_currentChapter', _currentChapter);
    await prefs.setStringList(
        'rp_readChapters', _readChapters.map((e) => e.toString()).toList());
    await prefs.setInt('rp_totalMinutes', _totalReadingMinutes);
    final keys = _scrollPositions.keys.map((k) => k.toString()).toList();
    await prefs.setStringList('rp_scrollKeys', keys);
  }

  // ─── Schedule cloud sync ──────────────────────────────────────────────────────
  void _scheduleCloudSync() {
    SyncService.scheduleSyncProgress(
      currentChapter: _currentChapter,
      readChapters: _readChapters.toList(),
      totalReadingMinutes: _totalReadingMinutes,
      scrollPositions: Map<int, double>.from(_scrollPositions),
    );
  }

  // ─── Public methods ──────────────────────────────────────────────────────────

  Future<void> setCurrentChapter(int index) async {
    _currentChapter = index;
    _readChapters.add(index);
    await _saveToLocal();
    _scheduleCloudSync();
    notifyListeners();
  }

  Future<void> saveScrollPosition(int chapterIndex, double position) async {
    _scrollPositions[chapterIndex] = position;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('rp_scroll_$chapterIndex', position);
    final keys = _scrollPositions.keys.map((k) => k.toString()).toList();
    await prefs.setStringList('rp_scrollKeys', keys);
    // Scroll pozitsiyani ham debounce bilan yuborish
    _scheduleCloudSync();
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
    _scheduleCloudSync();
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

  /// Progressni tiklash (test uchun)
  Future<void> resetProgress() async {
    _currentChapter = 0;
    _readChapters = {};
    _totalReadingMinutes = 0;
    _scrollPositions.clear();
    await _saveToLocal();

    // Clouddan ham o'chirish
    final uid = AuthService.uid;
    if (uid != null) {
      await FirestoreService.saveReadingProgress(
        uid: uid,
        currentChapter: 0,
        readChapters: [],
        totalReadingMinutes: 0,
        scrollPositions: {},
      );
    }
    notifyListeners();
  }
}