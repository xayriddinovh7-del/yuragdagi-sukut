import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/bookmark.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Bookmark> _bookmarks = [];
  Set<String> _favoriteQuotes = {};

  List<Bookmark> get bookmarks => _bookmarks;
  Set<String> get favoriteQuotes => _favoriteQuotes;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    final bookmarkList = prefs.getStringList('v2_bookmarks') ?? [];
    _bookmarks = bookmarkList
        .map((s) => Bookmark.fromStorageString(s))
        .toList();

    final quoteList = prefs.getStringList('v2_favoriteQuotes') ?? [];
    _favoriteQuotes = quoteList.toSet();

    notifyListeners();
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'v2_bookmarks',
      _bookmarks.map((b) => b.toStorageString()).toList(),
    );
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    _bookmarks.removeWhere((b) =>
        b.chapterIndex == bookmark.chapterIndex &&
        b.paragraphIndex == bookmark.paragraphIndex);
    _bookmarks.insert(0, bookmark);
    await _saveBookmarks();
    notifyListeners();
  }

  Future<void> removeBookmark(int chapterIndex, int paragraphIndex) async {
    _bookmarks.removeWhere((b) =>
        b.chapterIndex == chapterIndex && b.paragraphIndex == paragraphIndex);
    await _saveBookmarks();
    notifyListeners();
  }

  bool isBookmarked(int chapterIndex, int paragraphIndex) {
    return _bookmarks.any((b) =>
        b.chapterIndex == chapterIndex && b.paragraphIndex == paragraphIndex);
  }

  Future<void> toggleFavoriteQuote(String quote) async {
    if (_favoriteQuotes.contains(quote)) {
      _favoriteQuotes.remove(quote);
    } else {
      _favoriteQuotes.add(quote);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('v2_favoriteQuotes', _favoriteQuotes.toList());
    notifyListeners();
  }

  bool isQuoteFavorite(String quote) => _favoriteQuotes.contains(quote);
}