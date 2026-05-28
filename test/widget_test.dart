import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yurakdagi_sukut/app.dart';
import 'package:yurakdagi_sukut/providers/reading_provider.dart';
import 'package:yurakdagi_sukut/providers/settings_provider.dart';
import 'package:yurakdagi_sukut/providers/bookmark_provider.dart';
import 'package:yurakdagi_sukut/providers/auth_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'rp_currentChapter': 0,
      'rp_totalMinutes': 0,
      'rp_splashDone': false,
    });
  });

  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // 1. Create providers and initialize them
    final readingProvider = ReadingProvider();
    final settingsProvider = SettingsProvider();
    final bookmarkProvider = BookmarkProvider();
    final authProvider = AuthProvider();

    await readingProvider.init();
    await settingsProvider.init();
    await bookmarkProvider.init();

    // 2. Pump the main AytilmaganGaplarApp wrapped in MultiProvider
    await tester.pumpWidget(
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

    // 3. Verify the app successfully mounts and renders
    expect(find.byType(AytilmaganGaplarApp), findsOneWidget);

    // 4. Pump the sequential splash screen delayed futures in 1-second steps.
    // This allows sequential chained futures to trigger, execute, and clear cleanly.
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
  });
}
