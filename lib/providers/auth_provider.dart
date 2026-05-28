import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';

/// ─── Auth Provider ─────────────────────────────────────────────────────────────
/// Firebase auth holatini kuzatuvchi Provider.
/// Anonymous login avtomatik amalga oshiriladi.
class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;
  bool _isInitialized = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSignedIn => _user != null;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  String? get uid => _user?.uid;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    // Auth holati o'zgarishlarini kuzatish
    AuthService.authStateChanges.listen((user) {
      _user = user;
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
      debugPrint('🔐 Auth state changed: ${user?.uid ?? "null"}');
    });

    // Dastlabki anonymous login
    await _signInIfNeeded();
  }

  Future<void> _signInIfNeeded() async {
    if (AuthService.isSignedIn) {
      _user = AuthService.currentUser;
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final user = await AuthService.signInAnonymously();
      _user = user;
      _error = null;

      if (user != null) {
        // Sync service ni ishga tushirish
        await SyncService.initialize();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ AuthProvider init error: $e');
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Manual re-login (xato bo'lganda)
  Future<void> retry() async {
    _error = null;
    await _signInIfNeeded();
  }
}
