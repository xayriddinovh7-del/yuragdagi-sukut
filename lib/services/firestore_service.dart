import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:yurakdagi_sukut/data/models/bookmark.dart';

/// ─── Firestore Service ───────────────────────────────────────────────────────
/// Barcha Firestore CRUD operatsiyalar shu yerda.
///
/// Firestore struktura:
/// users/{uid}/
///   ├── profile          (document)
///   ├── reading_progress (document)
///   ├── settings         (document)
///   └── bookmarks/       (collection)
///       └── {bookmarkId} (document)
class FirestoreService {
  static bool get isSupported => Firebase.apps.isNotEmpty;

  static FirebaseFirestore get _db {
    if (!isSupported) {
      throw StateError('Firebase is not initialized.');
    }
    return FirebaseFirestore.instance;
  }

  // ─── Collection paths ──────────────────────────────────────────────────────
  static DocumentReference _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  static DocumentReference _progressDoc(String uid) =>
      _db.collection('users').doc(uid).collection('data').doc('reading_progress');

  static DocumentReference _settingsDoc(String uid) =>
      _db.collection('users').doc(uid).collection('data').doc('settings');

  static CollectionReference _bookmarksCol(String uid) =>
      _db.collection('users').doc(uid).collection('bookmarks');

  // ─── User Profile ──────────────────────────────────────────────────────────

  /// Foydalanuvchi profilini yaratish yoki yangilash
  static Future<void> createOrUpdateProfile(String uid) async {
    if (!isSupported) return;
    try {
      await _userDoc(uid).set({
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSeen': FieldValue.serverTimestamp(),
        'isAnonymous': true,
      }, SetOptions(merge: true));
      debugPrint('✅ Firestore: Profile updated for $uid');
    } catch (e) {
      debugPrint('❌ Firestore profile error: $e');
    }
  }

  /// Oxirgi faollik vaqtini yangilash
  static Future<void> updateLastSeen(String uid) async {
    if (!isSupported) return;
    try {
      await _userDoc(uid).update({'lastSeen': FieldValue.serverTimestamp()});
    } catch (e) {
      debugPrint('❌ Firestore updateLastSeen error: $e');
    }
  }

  // ─── Reading Progress ──────────────────────────────────────────────────────

  /// O'qish progressini Firestorega saqlash
  static Future<void> saveReadingProgress({
    required String uid,
    required int currentChapter,
    required List<int> readChapters,
    required int totalReadingMinutes,
    required Map<int, double> scrollPositions,
  }) async {
    if (!isSupported) return;
    try {
      await _progressDoc(uid).set({
        'currentChapter': currentChapter,
        'readChapters': readChapters,
        'totalReadingMinutes': totalReadingMinutes,
        'scrollPositions': scrollPositions.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint('✅ Firestore: Progress saved — chapter $currentChapter');
    } catch (e) {
      debugPrint('❌ Firestore saveProgress error: $e');
    }
  }

  /// Firestoredan o'qish progressini yuklash
  static Future<Map<String, dynamic>?> loadReadingProgress(String uid) async {
    if (!isSupported) return null;
    try {
      final doc = await _progressDoc(uid).get();
      if (!doc.exists) return null;
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('❌ Firestore loadProgress error: $e');
      return null;
    }
  }

  // ─── Settings ──────────────────────────────────────────────────────────────

  /// Sozlamalarni Firestorega saqlash
  static Future<void> saveSettings(String uid, Map<String, dynamic> settings) async {
    if (!isSupported) return;
    try {
      await _settingsDoc(uid).set(
        {...settings, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
      debugPrint('✅ Firestore: Settings saved');
    } catch (e) {
      debugPrint('❌ Firestore saveSettings error: $e');
    }
  }

  /// Firestoredan sozlamalarni yuklash
  static Future<Map<String, dynamic>?> loadSettings(String uid) async {
    if (!isSupported) return null;
    try {
      final doc = await _settingsDoc(uid).get();
      if (!doc.exists) return null;
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('❌ Firestore loadSettings error: $e');
      return null;
    }
  }

  // ─── Bookmarks ─────────────────────────────────────────────────────────────

  /// Bookmark qo'shish yoki yangilash
  static Future<void> saveBookmark(String uid, Bookmark bookmark) async {
    if (!isSupported) return;
    try {
      final docId = '${bookmark.chapterIndex}_${bookmark.paragraphIndex}';
      await _bookmarksCol(uid).doc(docId).set({
        'chapterIndex': bookmark.chapterIndex,
        'chapterTitle': bookmark.chapterTitle,
        'text': bookmark.text,
        'paragraphIndex': bookmark.paragraphIndex,
        'savedAt': bookmark.savedAt.millisecondsSinceEpoch,
        'note': bookmark.note ?? '',
      });
      debugPrint('✅ Firestore: Bookmark saved — ch${bookmark.chapterIndex}');
    } catch (e) {
      debugPrint('❌ Firestore saveBookmark error: $e');
    }
  }

  /// Bookmark o'chirish
  static Future<void> deleteBookmark(
      String uid, int chapterIndex, int paragraphIndex) async {
    if (!isSupported) return;
    try {
      final docId = '${chapterIndex}_$paragraphIndex';
      await _bookmarksCol(uid).doc(docId).delete();
      debugPrint('✅ Firestore: Bookmark deleted');
    } catch (e) {
      debugPrint('❌ Firestore deleteBookmark error: $e');
    }
  }

  /// Barcha bookmarklarni yuklash
  static Future<List<Bookmark>> loadBookmarks(String uid) async {
    if (!isSupported) return [];
    try {
      final snapshot = await _bookmarksCol(uid)
          .orderBy('savedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Bookmark(
          chapterIndex: data['chapterIndex'] as int? ?? 0,
          chapterTitle: data['chapterTitle'] as String? ?? '',
          text: data['text'] as String? ?? '',
          paragraphIndex: data['paragraphIndex'] as int? ?? 0,
          savedAt: DateTime.fromMillisecondsSinceEpoch(
            data['savedAt'] as int? ?? 0,
          ),
          note: (data['note'] as String?)?.isEmpty == true
              ? null
              : data['note'] as String?,
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ Firestore loadBookmarks error: $e');
      return [];
    }
  }

  // ─── Favorite Quotes ───────────────────────────────────────────────────────

  /// Sevimli iqtiboslarni saqlash
  static Future<void> saveFavoriteQuotes(
      String uid, Set<String> quotes) async {
    if (!isSupported) return;
    try {
      await _userDoc(uid).collection('data').doc('quotes').set({
        'favorites': quotes.toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('❌ Firestore saveFavoriteQuotes error: $e');
    }
  }

  /// Sevimli iqtiboslarni yuklash
  static Future<Set<String>> loadFavoriteQuotes(String uid) async {
    if (!isSupported) return {};
    try {
      final doc = await _userDoc(uid).collection('data').doc('quotes').get();
      if (!doc.exists) return {};
      final data = doc.data();
      final list = data?['favorites'] as List<dynamic>? ?? [];
      return list.cast<String>().toSet();
    } catch (e) {
      debugPrint('❌ Firestore loadFavoriteQuotes error: $e');
      return {};
    }
  }
}
