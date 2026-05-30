import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/reading_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/auth_provider.dart';
import 'services/sync_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    final exceptionStr = details.exceptionAsString();
    if (exceptionStr.contains('google_fonts') ||
        exceptionStr.contains('Failed to load font') ||
        exceptionStr.contains('Failed to fetch') ||
        exceptionStr.contains('Unexpected null value') ||
        exceptionStr.contains('Unable to load asset') ||
        exceptionStr.contains('HTTP request succeeded')) {
      debugPrint('ℹ️ Handled framework error: ${details.exception}');
      return;
    }
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    final errorStr = error.toString();
    if (errorStr.contains('google_fonts') ||
        errorStr.contains('Failed to load font') ||
        errorStr.contains('Failed to fetch') ||
        errorStr.contains('Unexpected null value') ||
        errorStr.contains('Unable to load asset') ||
        errorStr.contains('HTTP request succeeded')) {
      debugPrint('ℹ️ Handled asynchronous error: $error');
      return true;
    }
    return false;
  };

  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      debugPrint('🔥 Firebase successfully initialized.');
      await SyncService.initialize();
    } catch (e) {
      debugPrint('ℹ️ Firebase not configured, running in local mode: $e');
    }
  } else {
    debugPrint(
        'ℹ️ Web platformasida Firebase sozlanmagan — local rejimda ishlamoqda.');
  }

  final readingProvider = ReadingProvider();
  final settingsProvider = SettingsProvider();
  final bookmarkProvider = BookmarkProvider();
  final authProvider = AuthProvider();

  await Future.wait([
    readingProvider.init(),
    settingsProvider.init(),
    bookmarkProvider.init(),
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: readingProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: bookmarkProvider),
      ],
      child: const AytilmaganGaplarApp(),
    ),
  );
}
