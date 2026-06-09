import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/bookmark.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Bookmark> _bookmarks = [];
  Set<String> _favoriteQuotes = {};

  List<Bookmark> get bookmarks => _bookmarks;
  Set<String> get favoriteQuotes => _favoriteQuotes;

  // ─── Init ────────────────────────────────────────────────────────────────────
  Future<void> init() async {
    await _loadFromLocal();
    await _mergeFromCloud();
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    final bookmarkList = prefs.getStringList('v2_bookmarks') ?? [];
    _bookmarks = bookmarkList
        .map((s) => Bookmark.fromStorageString(s))
        .toList();

    final quoteList = prefs.getStringList('v2_favoriteQuotes') ?? [];
    _favoriteQuotes = quoteList.toSet();

    notifyListeners();
  }

  Future<void> _mergeFromCloud() async {
    final uid = AuthService.uid;
    if (uid == null) return;

    try {
      // Bookmarks
      final cloudBookmarks = await FirestoreService.loadBookmarks(uid);
      if (cloudBookmarks.isNotEmpty) {
        // Lokal + cloud birlashtirish (dublikat yo'q)
        final merged = <String, Bookmark>{};
        for (final b in _bookmarks) {
          merged['${b.chapterIndex}_${b.paragraphIndex}'] = b;
        }
        for (final b in cloudBookmarks) {
          final key = '${b.chapterIndex}_${b.paragraphIndex}';
          // Cloud yangroq bo'lsa uni olish
          if (!merged.containsKey(key) ||
              b.savedAt.isAfter(merged[key]!.savedAt)) {
            merged[key] = b;
          }
        }
        _bookmarks = merged.values.toList()
          ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
        await _saveLocalBookmarks();
      }

      // Favorite quotes
      final cloudQuotes = await FirestoreService.loadFavoriteQuotes(uid);
      if (cloudQuotes.isNotEmpty) {
        _favoriteQuotes = {..._favoriteQuotes, ...cloudQuotes};
        await _saveLocalQuotes();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('ℹ️ BookmarkProvider: Cloud merge skipped — $e');
    }
  }

  // ─── Local persistence ────────────────────────────────────────────────────────
  Future<void> _saveLocalBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'v2_bookmarks',
      _bookmarks.map((b) => b.toStorageString()).toList(),
    );
  }

  Future<void> _saveLocalQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('v2_favoriteQuotes', _favoriteQuotes.toList());
  }

  // ─── Bookmark CRUD ────────────────────────────────────────────────────────────
  Future<void> addBookmark(Bookmark bookmark) async {
    _bookmarks.removeWhere((b) =>
        b.chapterIndex == bookmark.chapterIndex &&
        b.paragraphIndex == bookmark.paragraphIndex);
    _bookmarks.insert(0, bookmark);
    await _saveLocalBookmarks();
    notifyListeners();

    // Cloud sync
    final uid = AuthService.uid;
    if (uid != null) {
      await FirestoreService.saveBookmark(uid, bookmark);
    }
  }

  Future<void> removeBookmark(int chapterIndex, int paragraphIndex) async {
    _bookmarks.removeWhere((b) =>
        b.chapterIndex == chapterIndex && b.paragraphIndex == paragraphIndex);
    await _saveLocalBookmarks();
    notifyListeners();

    // Cloud sync
    final uid = AuthService.uid;
    if (uid != null) {
      await FirestoreService.deleteBookmark(uid, chapterIndex, paragraphIndex);
    }
  }

  bool isBookmarked(int chapterIndex, int paragraphIndex) {
    return _bookmarks.any((b) =>
        b.chapterIndex == chapterIndex && b.paragraphIndex == paragraphIndex);
  }

  // ─── Favorite Quotes ──────────────────────────────────────────────────────────
  Future<void> toggleFavoriteQuote(String quote) async {
    if (_favoriteQuotes.contains(quote)) {
      _favoriteQuotes.remove(quote);
    } else {
      _favoriteQuotes.add(quote);
    }
    await _saveLocalQuotes();
    notifyListeners();

    // Cloud sync
    final uid = AuthService.uid;
    if (uid != null) {
      await FirestoreService.saveFavoriteQuotes(uid, _favoriteQuotes);
    }
  }

  bool isQuoteFavorite(String quote) => _favoriteQuotes.contains(quote);
}