import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/reading_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/bookmark_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─── Global Asynchronous & Layout Error Boundary ───────────────────────────
  FlutterError.onError = (FlutterErrorDetails details) {
    final exceptionStr = details.exceptionAsString();
    if (exceptionStr.contains('google_fonts') ||
        exceptionStr.contains('Failed to load font') ||
        exceptionStr.contains('Failed to fetch') ||
        exceptionStr.contains('Unexpected null value')) {
      debugPrint('ℹ️ Handled GoogleFonts framework error: ${details.exception}');
      return;
    }
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    final errorStr = error.toString();
    if (errorStr.contains('google_fonts') ||
        errorStr.contains('Failed to load font') ||
        errorStr.contains('Failed to fetch') ||
        errorStr.contains('Unexpected null value')) {
      debugPrint('ℹ️ Handled GoogleFonts asynchronous error: $error');
      return true; // Marks the error as handled to prevent runtime crashes
    }
    return false; // Propagates other unhandled errors
  };

  final readingProvider = ReadingProvider();
  final settingsProvider = SettingsProvider();
  final bookmarkProvider = BookmarkProvider();

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
        ChangeNotifierProvider.value(value: readingProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: bookmarkProvider),
      ],
      child: const AytilmaganGaplarApp(),
    ),
  );
}
