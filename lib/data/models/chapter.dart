// ─── Chapter Model ─────────────────────────────────────────────────────────────
class Chapter {
  final String id;
  final String title;
  final String content;
  final int index;
  final String? quoteHighlight;

  const Chapter({
    required this.id,
    required this.title,
    required this.content,
    required this.index,
    this.quoteHighlight,
  });

  List<String> get paragraphs =>
      content.split('\n\n').where((p) => p.trim().isNotEmpty).toList();

  int get wordCount => content.split(RegExp(r'\s+')).length;

  int get estimatedReadMinutes => (wordCount / 200).ceil();

  bool isParagraphDialogue(String paragraph) {
    final t = paragraph.trim();
    return t.startsWith('—') || t.startsWith('–') || t.startsWith('"') || t.startsWith('«') || t.startsWith('-');
  }
}
