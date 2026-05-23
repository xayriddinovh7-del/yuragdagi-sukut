// ─── Image URLs ────────────────────────────────────────────────────────────────
// All cinematic images for Aytilmagan gaplar

class ImageUrls {
  // ── Splash / Home backgrounds ─────────────────────────────────────────────
  /// Asosiy splash ekran — kitob muqovasi rasmi
  static const splashBg = 'assets/image.png';

  /// Home screen fon rasmi
  static const homeBg = 'assets/image copy 3.png';

  /// Reader dark mode fon
  static const readerDarkBg = 'assets/image copy 2.png';

  /// Reader light mode fon
  static const readerLightBg = 'assets/image copy 4.png';

  // ── Book cover (sidebar & mobile stats card) ──────────────────────────────
  /// Kitob muqovasi — splash rasmi
  static const bookCover = 'assets/image.png';

  // ── Chapter mood header images ─────────────────────────────────────────────
  // Bob tartibiga mos rasmlar:
  //   0 → Kirish          (kitob muqovasi)
  //   1 → I  BOB: Sukut ortidagi ko'zlar
  //   2 → II BOB: Ketgan izlar
  //   3 → III BOB: Aytilmagan gaplar
  //   4 → IV BOB: Yomg'irdagi xotiralar
  //   5 → V  BOB: U qaytgan kun
  //   6 → VI BOB: Ali'ning sukuti
  //   7 → VII BOB: Qaytish
  //   8 → VIII BOB: Kechikkan baxt
  static const Map<int, String> chapterImages = {
    0: 'assets/image.png',              // Kirish — kitob muqovasi
    1: 'assets/image copy.png',          // I BOB  — Sukut ortidagi ko'zlar
    2: 'assets/image copy 2.png',        // II BOB — Ketgan izlar
    3: 'assets/image copy 3.png',        // III BOB — Aytilmagan gaplar
    4: 'assets/image copy 4.png',        // IV BOB — Yomg'irdagi xotiralar
    5: 'assets/image copy 5.png',        // V BOB  — U qaytgan kun
    6: 'assets/chapter5_silence.png',    // VI BOB — Ali'ning sukuti
    7: 'assets/chapter7_qaytish.png',    // VII BOB — Qaytish
    8: 'assets/image copy 6.png',        // VIII BOB — Kechikkan baxt
  };

  static String chapterImage(int index) =>
      chapterImages[index] ?? chapterImages[0]!;
}
