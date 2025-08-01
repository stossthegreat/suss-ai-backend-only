class HistoryItem {
  final int id;
  final String preview;
  final String motive;
  final int score;
  final String date;
  final String category;

  const HistoryItem({
    required this.id,
    required this.preview,
    required this.motive,
    required this.score,
    required this.date,
    required this.category,
  });

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id']?.toInt() ?? 0,
      preview: map['preview'] ?? '',
      motive: map['motive'] ?? '',
      score: map['score']?.toInt() ?? 0,
      date: map['date'] ?? '',
      category: map['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'preview': preview,
      'motive': motive,
      'score': score,
      'date': date,
      'category': category,
    };
  }
} 