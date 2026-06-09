import 'package:flutter/foundation.dart';
import '../models/book_data.dart';
import '../services/api_service.dart';

/// ─── Yuklash holati ────────────────────────────────────────────────────────────
enum BookLoadState {
  initial,    // Hali yuklanmagan
  loading,    // Yuklanmoqda
  loaded,     // Serverdan yuklandi
  fallback,   // Lokal ma'lumot ishlatilmoqda (server mavjud emas)
  error,      // Xato
}

/// ─── BookProvider ──────────────────────────────────────────────────────────────
/// Kitob boblarini boshqaruvchi Provider.
///
/// Strategiya:
/// 1. App ishga tushganda lokal ma'lumotni darhol ko'rsatish (tezkor)
/// 2. Background'da server tekshirish
/// 3. Server mavjud bo'lsa — serverdan boblarni yuklash va yangilash
/// 4. Server mavjud bo'lmasa — lokal (statik) ma'lumot bilan ishlashda davom etish
///
/// Bu "Offline-first" arxitektura: foydalanuvchi doim kitobni o'qiy oladi,
/// server faqat yangi/ko'proq content qo'shish imkonini beradi.
class BookProvider extends ChangeNotifier {
  // ─── State ──────────────────────────────────────────────────────────────────
  BookLoadState _loadState = BookLoadState.initial;
  List<Chapter> _serverChapters = [];
  String? _error;
  bool _serverAvailable = false;

  // ─── Getters ─────────────────────────────────────────────────────────────────

  BookLoadState get loadState => _loadState;
  bool get isServerAvailable => _serverAvailable;
  bool get isLoading => _loadState == BookLoadState.loading;
  String? get error => _error;

  /// Serverdan yuklangan boblar soni
  int get serverChapterCount => _serverChapters.length;

  /// Joriy til bo'yicha boblar ro'yxatini qaytarish.
  /// Server mavjud bo'lsa — server ma'lumotlari (faqat o'zbekcha).
  /// Server mavjud bo'lmasa — lokal til-specific ma'lumotlar.
  List<Chapter> getChapters(String lang) {
    if (_serverAvailable && _serverChapters.isNotEmpty) {
      // Server o'zbek tilida ma'lumot beradi.
      // Boshqa tillar uchun lokal fallback ishlatiladi.
      if (lang == 'uz') {
        return _serverChapters;
      }
    }
    return BookData.getChapters(lang);
  }

  /// Bitta bobni qaytarish (server yoki lokal)
  Chapter getChapter(int index, String lang) {
    final chapters = getChapters(lang);
    if (index < 0 || index >= chapters.length) {
      return chapters.isNotEmpty ? chapters[0] : _emptyChapter(index);
    }
    return chapters[index];
  }

  /// Boblar sonini qaytarish
  int getChapterCount(String lang) => getChapters(lang).length;

  /// Kitob nomini qaytarish
  String getTitle(String lang) => BookData.getTitle(lang);

  /// Kitob tavsifini qaytarish
  String getDescription(String lang) => BookData.getDescription(lang);

  // ─── Initialization ──────────────────────────────────────────────────────────

  /// App ishga tushganda chaqiriladi.
  /// Birinchi lokal ma'lumot ishlatiladi, keyin server tekshiriladi.
  Future<void> init() async {
    // Lokal ma'lumot allaqachon BookData da mavjud — UI darhol ko'rsatiladi
    _loadState = BookLoadState.fallback;
    notifyListeners();

    // Background'da server tekshirish va yuklash
    await _tryLoadFromServer();
  }

  // ─── Server Loading ──────────────────────────────────────────────────────────

  /// Serverdan ma'lumot yuklashga urinish.
  /// Xato bo'lsa — jim o'tadi (lokal ma'lumot ishlatiladi).
  Future<void> _tryLoadFromServer() async {
    try {
      _loadState = BookLoadState.loading;
      notifyListeners();

      // Server sog'lig'ini tekshirish
      final isHealthy = await ApiService.checkHealth();
      if (!isHealthy) {
        debugPrint('ℹ️ BookProvider: Server mavjud emas — lokal rejimda');
        _loadState = BookLoadState.fallback;
        _serverAvailable = false;
        notifyListeners();
        return;
      }

      // Barcha boblarni parallel yuklash
      final chapters = await ApiService.fetchAllChapters();
      if (chapters == null || chapters.isEmpty) {
        debugPrint('ℹ️ BookProvider: Serverdan bob kelmadi — lokal rejimda');
        _loadState = BookLoadState.fallback;
        _serverAvailable = false;
        notifyListeners();
        return;
      }

      _serverChapters = chapters;
      _serverAvailable = true;
      _loadState = BookLoadState.loaded;
      _error = null;
      debugPrint('✅ BookProvider: ${chapters.length} ta bob serverdan yuklandi');
      notifyListeners();
    } catch (e) {
      debugPrint('ℹ️ BookProvider: Server xatosi — $e');
      _loadState = BookLoadState.fallback;
      _serverAvailable = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Serverni qayta tekshirish (masalan, tarmoq tiklanganda)
  Future<void> refresh() async {
    await _tryLoadFromServer();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  /// Bo'sh placeholder Chapter
  Chapter _emptyChapter(int index) {
    return Chapter(
      id: index.toString(),
      index: index,
      title: '...',
      content: '',
    );
  }

  /// Server holati haqida matn (debugging uchun)
  String get statusText {
    switch (_loadState) {
      case BookLoadState.initial:
        return 'Yuklanmagan';
      case BookLoadState.loading:
        return 'Yuklanmoqda...';
      case BookLoadState.loaded:
        return '✅ Server: ${_serverChapters.length} bob';
      case BookLoadState.fallback:
        return '📱 Lokal rejim';
      case BookLoadState.error:
        return '❌ Xato: $_error';
    }
  }
}
