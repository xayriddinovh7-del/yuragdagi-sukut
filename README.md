# 📖 Yurakdagi Sukut — Flutter Ilovasi

O'zbek sevgi romani "Yurakdagi Sukut"ning Flutter mobil ilovasi.

## 🚀 Ishga tushirish

### Talablar
- Flutter SDK (3.0.0 yoki yuqori)
- Dart SDK
- Android Studio / VS Code

### O'rnatish

```bash
# 1. Papkaga o'ting
cd yurakdagi_sukut

# 2. Paketlarni o'rnating
flutter pub get

# 3. Ilovani ishga tushiring
flutter run
```

## 📱 Ilova xususiyatlari

### Asosiy
- ✅ **Splash screen** — chiroyli kirish animatsiyasi
- ✅ **Boblar ro'yxati** — barcha 9 bob batafsil ko'rsatiladi
- ✅ **O'qish tartibi** — boblar ketma-ket o'qiladi
- ✅ **Progress tracker** — qancha o'qilganini foizda ko'rsatadi

### O'qish
- ✅ **Shrift hajmi** — kattalashtirish/kichraytirish (12–28pt)
- ✅ **Tungi rejim** — qorong'u/yorug' tema
- ✅ **Dialog ranglar** — dialog satrlar binafsha rang bilan ajratiladi
- ✅ **Qulay navigatsiya** — oldingi/keyingi bob tugmalari

### Saqlash
- ✅ **O'qish o'rni saqlanadi** — ilova yopilsa ham davom ettiriladi
- ✅ **O'qilgan boblar belgilanadi** — yashil belgi bilan ko'rsatiladi
- ✅ **Sozlamalar saqlanadi** — tema, shrift o'lcham

## 📚 Kitob tarkibi

| # | Bob nomi |
|---|----------|
| 1 | Kirish |
| 2 | Sukut ortidagi ko'zlar |
| 3 | Ketgan izlar |
| 4 | Aytilmagan gaplar |
| 5 | Yomg'irdagi xotiralar |
| 6 | U qaytgan kun |
| 7 | Ali'ning sukuti |
| 8 | Qaytish |
| 9 | Kechikkan baxt |

## 🏗️ Loyiha tuzilishi

```
lib/
├── main.dart                  # Kirish nuqta
├── models/
│   └── book_data.dart         # Kitob ma'lumotlari
├── utils/
│   └── reading_provider.dart  # Holat boshqaruvi
└── screens/
    ├── splash_screen.dart     # Kirish ekrani
    ├── home_screen.dart       # Asosiy ekran (boblar)
    └── reading_screen.dart    # O'qish ekrani
```

## 🛠️ Ishlatilgan paketlar

- `google_fonts` — Playfair Display, Noto Serif, Lato shriftlari
- `provider` — holat boshqaruvi
- `shared_preferences` — sozlamalar saqlash
