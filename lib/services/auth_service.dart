import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// ─── Firebase Authentication Service ─────────────────────────────────────────
/// Anonymous auth — foydalanuvchi kirmasdan bulut sinkronizatsiyasidan foydalana oladi.
/// Keyinchalik Google/Apple login bilan bog'lash mumkin.
class AuthService {
  /// Firebase loyiha mavjudligini tekshirish
  static bool get isSupported => Firebase.apps.isNotEmpty;

  static FirebaseAuth get _auth {
    if (!isSupported) {
      throw StateError('Firebase is not initialized.');
    }
    return FirebaseAuth.instance;
  }

  /// Joriy foydalanuvchini olish
  static User? get currentUser => isSupported ? _auth.currentUser : null;

  /// Joriy foydalanuvchi UID
  static String? get uid => isSupported ? _auth.currentUser?.uid : 'local_user';

  /// Foydalanuvchi kirganmi?
  static bool get isSignedIn => isSupported && _auth.currentUser != null;

  /// Auth holati o'zgarishlarini kuzatish
  static Stream<User?> get authStateChanges =>
      isSupported ? _auth.authStateChanges() : Stream<User?>.value(null);

  /// ── Anonymous Login ─────────────────────────────────────────────────────────
  /// Agar foydalanuvchi allaqachon kirgan bo'lsa, hech narsa qilmaydi.
  /// Yangi foydalanuvchi bo'lsa, anonymous account yaratadi.
  static Future<User?> signInAnonymously() async {
    if (!isSupported) {
      debugPrint('ℹ️ Auth: Firebase is not available. Running in local mode.');
      return null;
    }
    try {
      // Agar allaqachon kirgan bo'lsa qaytarish
      if (_auth.currentUser != null) {
        debugPrint('✅ Auth: Already signed in — ${_auth.currentUser!.uid}');
        return _auth.currentUser;
      }

      final credential = await _auth.signInAnonymously();
      debugPrint('✅ Auth: Anonymous sign-in successful — ${credential.user?.uid}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Auth error: ${e.code} — ${e.message}');
      return null;
    } catch (e) {
      debugPrint('❌ Auth unexpected error: $e');
      return null;
    }
  }

  /// ── Sign Out ────────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    if (!isSupported) return;
    try {
      await _auth.signOut();
      debugPrint('✅ Auth: Signed out successfully');
    } catch (e) {
      debugPrint('❌ Auth sign out error: $e');
    }
  }

  /// ── UID ni xavfsiz olish ────────────────────────────────────────────────────
  /// Agar kirgan bo'lmasa, anonymous kirish amalga oshiriladi.
  static Future<String?> ensureUid() async {
    if (!isSupported) return 'local_user';
    if (_auth.currentUser != null) return _auth.currentUser!.uid;
    final user = await signInAnonymously();
    return user?.uid;
  }
}
