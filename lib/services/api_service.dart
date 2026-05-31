import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/book_data.dart';

/// ─── API Service ───────────────────────────────────────────────────────────────
/// Dart Shelf backend serveriga HTTP so'rovlar yuboradigan servis.
///
/// Endpoint'lar:
///   GET /api/books              — kitob metadata
///   GET /api/books/chapters     — barcha boblar (content'siz)
///   GET /api/books/chapters/:id — bitta bob (content bilan)
///
/// Agar server mavjud bo'lmasa, null qaytadi va lokal ma'lumot ishlatiladi.
class ApiService {
  /// ─── Server URL ─────────────────────────────────────────────────────────────
  /// Real production server: http://109.94.175.237:8080
  /// Local dev server:       http://localhost:8080
  static const String _baseUrl = 'http://109.94.175.237:8080';

  static const Duration _timeout = Duration(seconds: 8);

  // ─── Book Meta ──────────────────────────────────────────────────────────────

  /// Kitob metadata'sini serverdan olish
  static Future<Map<String, dynamic>?> fetchBookMeta() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/api/books'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['success'] == true) {
          return json['data'] as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      debugPrint('ℹ️ ApiService: fetchBookMeta failed — $e');
    }
    return null;
  }

  // ─── Chapters List ──────────────────────────────────────────────────────────

  /// Barcha boblar ro'yxatini serverdan olish (content'siz, tez)
  static Future<List<Chapter>?> fetchChaptersList() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/api/books/chapters'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['success'] == true) {
          final list = json['data'] as List<dynamic>;
          return list
              .map((item) => _parseChapter(item as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('ℹ️ ApiService: fetchChaptersList failed — $e');
    }
    return null;
  }

  // ─── Single Chapter ─────────────────────────────────────────────────────────

  /// Bitta bobni index bo'yicha serverdan olish (content bilan)
  static Future<Chapter?> fetchChapter(int index) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/api/books/chapters/$index'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['success'] == true) {
          return _parseChapter(json['data'] as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('ℹ️ ApiService: fetchChapter($index) failed — $e');
    }
    return null;
  }

  // ─── All Chapters with Content ──────────────────────────────────────────────

  /// Barcha boblarni content bilan birga yuklash.
  /// Chapters count'ini bilib, parallel ravishda har birini yuklaydi.
  static Future<List<Chapter>?> fetchAllChapters() async {
    try {
      // Avval metadata dan chapter count'ini olish
      final meta = await fetchBookMeta();
      if (meta == null) return null;

      final count = meta['chapterCount'] as int? ?? 0;
      if (count == 0) return null;

      // Parallel ravishda barcha boblarni yuklash
      final futures = List.generate(count, (i) => fetchChapter(i));
      final results = await Future.wait(futures);

      // Null bo'lmagan natijalarni filtrlash
      final chapters = results.whereType<Chapter>().toList();

      if (chapters.length < count) {
        debugPrint('⚠️ ApiService: Faqat ${chapters.length}/$count bob yuklandi');
        return chapters.isEmpty ? null : chapters;
      }

      debugPrint('✅ ApiService: ${chapters.length} ta bob serverdan yuklandi');
      return chapters;
    } catch (e) {
      debugPrint('❌ ApiService: fetchAllChapters failed — $e');
      return null;
    }
  }

  // ─── Server Health ──────────────────────────────────────────────────────────

  /// Server ishlayotganini tekshirish
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ─── Parser ─────────────────────────────────────────────────────────────────

  /// JSON dan Chapter ob'ektiga aylantirish
  static Chapter _parseChapter(Map<String, dynamic> json) {
    return Chapter(
      id: (json['id'] as Object?)?.toString() ?? '0',
      index: json['index'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }
}
