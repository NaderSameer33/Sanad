class Verse {
  final int number;
  final String textAr;
  final String textEn;
  final int juz;
  final int page;
  final bool sajda;

  const Verse({
    required this.number,
    required this.textAr,
    required this.textEn,
    required this.juz,
    required this.page,
    required this.sajda,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    final textMap = json['text'] as Map<String, dynamic>? ?? {};
    return Verse(
      number: json['number'] as int? ?? 1,
      textAr: textMap['ar'] as String? ?? '',
      textEn: textMap['en'] as String? ?? '',
      juz: json['juz'] as int? ?? 1,
      page: json['page'] as int? ?? 1,
      sajda: json['sajda'] is bool ? json['sajda'] as bool : false,
    );
  }
}

class Surah {
  final int number;
  final String nameAr;
  final String nameEn;
  final String transliteration;
  final String revelationPlace;
  final int versesCount;
  final int wordsCount;
  final int lettersCount;
  final List<Verse> verses;

  const Surah({
    required this.number,
    required this.nameAr,
    required this.nameEn,
    required this.transliteration,
    required this.revelationPlace,
    required this.versesCount,
    required this.wordsCount,
    required this.lettersCount,
    required this.verses,
  });

  bool get isMakki => revelationPlace == 'مكية' || revelationPlace == 'meccan';

  factory Surah.fromJson(Map<String, dynamic> json) {
    final nameMap = json['name'] as Map<String, dynamic>? ?? {};
    final revMap = json['revelation_place'] as Map<String, dynamic>? ?? {};
    final rawVerses = json['verses'] as List<dynamic>? ?? [];

    return Surah(
      number: json['number'] as int? ?? 1,
      nameAr: nameMap['ar'] as String? ?? '',
      nameEn: nameMap['en'] as String? ?? '',
      transliteration: nameMap['transliteration'] as String? ?? '',
      revelationPlace: revMap['ar'] as String? ?? 'مكية',
      versesCount: json['verses_count'] as int? ?? 0,
      wordsCount: json['words__count'] as int? ?? 0,
      lettersCount: json['letters__count'] as int? ?? 0,
      verses: rawVerses
          .map((v) => Verse.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}

class JuzItem {
  final int juzNumber;
  final String startSurahName;
  final int startVerseNumber;
  final int pageNumber;

  const JuzItem({
    required this.juzNumber,
    required this.startSurahName,
    required this.startVerseNumber,
    required this.pageNumber,
  });
}
