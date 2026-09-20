class ThikrItem {
  final String category;
  final int targetCount;
  final String description;
  final String reference;
  final String content;

  const ThikrItem({
    required this.category,
    required this.targetCount,
    required this.description,
    required this.reference,
    required this.content,
  });

  factory ThikrItem.fromJson(Map<String, dynamic> json) {
    int parsedCount = 1;
    final rawCount = json['count'];
    if (rawCount is int) {
      parsedCount = rawCount;
    } else if (rawCount is String) {
      parsedCount = int.tryParse(rawCount.trim()) ?? 1;
    }

    return ThikrItem(
      category: json['category'] as String? ?? '',
      targetCount: parsedCount > 0 ? parsedCount : 1,
      description: json['description'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }
}

class AthkarCategoryGroup {
  final String title;
  final List<ThikrItem> items;

  const AthkarCategoryGroup({
    required this.title,
    required this.items,
  });
}
