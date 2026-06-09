// ─── Bookmark Model ─────────────────────────────────────────────────────────────
class Bookmark {
  final int chapterIndex;
  final String chapterTitle;
  final String text;
  final int paragraphIndex;
  final DateTime savedAt;
  final String? note;

  const Bookmark({
    required this.chapterIndex,
    required this.chapterTitle,
    required this.text,
    required this.paragraphIndex,
    required this.savedAt,
    this.note,
  });

  String toStorageString() =>
      '$chapterIndex|||$chapterTitle|||$text|||$paragraphIndex|||${savedAt.millisecondsSinceEpoch}|||${note ?? ""}';

  static Bookmark fromStorageString(String s) {
    final parts = s.split('|||');
    if (parts.length < 5) {
      // Legacy format fallback
      final oldParts = s.split('|');
      return Bookmark(
        chapterIndex: int.tryParse(oldParts[0]) ?? 0,
        chapterTitle: oldParts.length > 1 ? oldParts[1] : '',
        text: oldParts.length > 2 ? oldParts[2] : '',
        paragraphIndex:
            oldParts.length > 3 ? (int.tryParse(oldParts[3]) ?? 0) : 0,
        savedAt: oldParts.length > 4
            ? DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(oldParts[4]) ?? 0)
            : DateTime.now(),
      );
    }
    return Bookmark(
      chapterIndex: int.tryParse(parts[0]) ?? 0,
      chapterTitle: parts[1],
      text: parts[2],
      paragraphIndex: int.tryParse(parts[3]) ?? 0,
      savedAt: DateTime.fromMillisecondsSinceEpoch(int.tryParse(parts[4]) ?? 0),
      note: parts.length > 5 && parts[5].isNotEmpty ? parts[5] : null,
    );
  }

  Bookmark copyWith({String? note}) => Bookmark(
        chapterIndex: chapterIndex,
        chapterTitle: chapterTitle,
        text: text,
        paragraphIndex: paragraphIndex,
        savedAt: savedAt,
        note: note ?? this.note,
      );
}
