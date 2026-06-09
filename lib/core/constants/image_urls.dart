// ─── Image URLs ────────────────────────────────────────────────────────────────
// All cinematic images for Yuragdagi Sukut

class ImageUrls {
  // ── Splash / Home backgrounds ─────────────────────────────────────────────
  /// Asosiy splash ekran — kitob muqovasi rasmi
  static const splashBg = 'assets/feather.jpeg';

  /// Home screen fon rasmi
  static const homeBg = 'assets/image copy 3.png';

  /// Reader dark mode fon
  static const readerDarkBg = 'assets/image copy 2.png';

  /// Reader light mode fon
  static const readerLightBg = 'assets/image copy 4.png';

  // ── Book cover (sidebar & mobile stats card) ──────────────────────────────
  /// Kitob muqovasi — splash rasmi
  static const bookCover = 'assets/feather.jpeg';

  // ── Chapter mood header images ─────────────────────────────────────────────
  // Bob tartibiga mos rasmlar:
  //   0 → Kirish          (kitob muqovasi)
  //   1 → I  BOB: Sukut ortidagi ko'zlar
  //   2 → II BOB: Ketgan izlar
  //   3 → III BOB: Yuragdagi Sukut
  //   4 → IV BOB: Yomg'irdagi xotiralar
  //   5 → V  BOB: U qaytgan kun
  //   6 → VI BOB: Ali'ning sukuti
  //   7 → VII BOB: Qaytish
  //   8 → VIII BOB: Kechikkan baxt
  static const Map<int, String> chapterImages = {
    0: 'assets/feather.jpeg', // Kirish — kitob muqovasi
    1: 'assets/image copy.png', // I BOB  — Sukut ortidagi ko'zlar
    2: 'assets/image copy 2.png', // II BOB — Ketgan izlar
    3: 'assets/image copy 3.png', // III BOB — Yuragdagi Sukut
    4: 'assets/image copy 4.png', // IV BOB — Yomg'irdagi xotiralar
    5: 'assets/image copy 5.png', // V BOB  — U qaytgan kun
    6: 'assets/image copy 6.png', // VI BOB — Ali'ning sukuti
    7: 'assets/image copy 5.png', // VII BOB — Qaytish
    8: 'assets/image copy 6.png', // VIII BOB — Kechikkan baxt
  };

  static String chapterImage(int index) =>
      chapterImages[index] ?? chapterImages[0]!;
}
