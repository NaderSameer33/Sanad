class PrayerTimeItem {
  final String name;
  final String time;
  final bool isNext;
  final bool isPassed;

  const PrayerTimeItem({
    required this.name,
    required this.time,
    this.isNext = false,
    this.isPassed = false,
  });
}

class VerseOfDay {
  final String surahName;
  final int ayahNumber;
  final String arabicText;
  final String tafsirSource;
  final String tafsirText;

  const VerseOfDay({
    required this.surahName,
    required this.ayahNumber,
    required this.arabicText,
    required this.tafsirSource,
    required this.tafsirText,
  });
}

class WirdProgress {
  final String title;
  final int completedCount;
  final int totalCount;
  final String nextDhikr;

  const WirdProgress({
    required this.title,
    required this.completedCount,
    required this.totalCount,
    required this.nextDhikr,
  });

  double get progress => totalCount > 0 ? completedCount / totalCount : 0.0;
  int get percent => (progress * 100).toInt();
}
