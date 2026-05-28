import 'dart:async';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

/// ─── Sync Service ─────────────────────────────────────────────────────────────
/// Local SharedPreferences ↔ Cloud Firestore sinkronizatsiya.
///
/// Strategiya:
/// 1. App ishga tushganda → Firebase'dan yuklash (agar yangroq bo'lsa)
/// 2. O'zgarish bo'lganda → Debounce bilan Firestorega yozish (3 soniyadan keyin)
/// 3. Offline bo'lganda → Lokal ishlaydi, internet qaytganda sync bo'ladi
class SyncService {
  static Timer? _syncDebounce;
  static bool _isSyncing = false;

  static const Duration _debounceDelay = Duration(seconds: 3);

  /// ── Initialize ──────────────────────────────────────────────────────────────
  /// App ishga tushganda chaqiriladi.
  /// Anonymous login + profil yaratish.
  static Future<void> initialize() async {
    if (!AuthService.isSupported) {
      debugPrint('ℹ️ Sync: Firebase is not supported/configured. Running in offline/local-only mode.');
      return;
    }
    try {
      final uid = await AuthService.ensureUid();
      if (uid == null) {
        debugPrint('ℹ️ Sync: No UID, running in offline mode');
        return;
      }
      await FirestoreService.createOrUpdateProfile(uid);
      debugPrint('✅ Sync: Initialized for $uid');
    } catch (e) {
      debugPrint('❌ Sync init error: $e');
    }
  }

  /// ── Debounced Progress Sync ─────────────────────────────────────────────────
  /// O'qish progress o'zgarganda 3 soniya kutib, keyin Firestorega yozadi.
  /// (Har sahifa o'qilganda ko'p so'rovlar jo'natmaslik uchun)
  static void scheduleSyncProgress({
    required int currentChapter,
    required List<int> readChapters,
    required int totalReadingMinutes,
    required Map<int, double> scrollPositions,
  }) {
    _syncDebounce?.cancel();
    _syncDebounce = Timer(_debounceDelay, () async {
      final uid = AuthService.uid;
      if (uid == null) return;

      if (_isSyncing) return;
      _isSyncing = true;
      try {
        await FirestoreService.saveReadingProgress(
          uid: uid,
          currentChapter: currentChapter,
          readChapters: readChapters,
          totalReadingMinutes: totalReadingMinutes,
          scrollPositions: scrollPositions,
        );
      } finally {
        _isSyncing = false;
      }
    });
  }

  /// ── Settings Sync ───────────────────────────────────────────────────────────
  static void scheduleSyncSettings(Map<String, dynamic> settings) {
    Timer(_debounceDelay, () async {
      final uid = AuthService.uid;
      if (uid == null) return;
      await FirestoreService.saveSettings(uid, settings);
    });
  }

  /// ── Load from Cloud ─────────────────────────────────────────────────────────
  /// Firestoredan progress yuklash. Null qaytsa — lokal ma'lumot ishlatiladi.
  static Future<Map<String, dynamic>?> loadProgressFromCloud() async {
    final uid = AuthService.uid;
    if (uid == null) return null;
    return FirestoreService.loadReadingProgress(uid);
  }

  /// Firestoredan sozlamalar yuklash
  static Future<Map<String, dynamic>?> loadSettingsFromCloud() async {
    final uid = AuthService.uid;
    if (uid == null) return null;
    return FirestoreService.loadSettings(uid);
  }

  /// ── Cleanup ─────────────────────────────────────────────────────────────────
  static void dispose() {
    _syncDebounce?.cancel();
  }
}
