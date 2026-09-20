import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../../core/services/cache_service.dart';
import '../models/quran_models.dart';

abstract class QuranRepository {
  Future<List<Surah>> getAllSurahs();
  Future<Surah?> getSurahByNumber(int number);
  Future<List<Surah>> searchSurahs(String query);
  Future<List<JuzItem>> getJuzList();
  Future<Verse?> getRandomVerse();
  Future<void> saveLastRead({required int surahNumber, required int verseNumber, required int pageNumber});
  Map<String, dynamic>? getLastRead();
}

class QuranRepositoryImpl implements QuranRepository {
  List<Surah>? _cachedSurahs;

  static const String _keyLastSurah = 'last_read_surah';
  static const String _keyLastVerse = 'last_read_verse';
  static const String _keyLastPage = 'last_read_page';

  @override
  Future<List<Surah>> getAllSurahs() async {
    if (_cachedSurahs != null) return _cachedSurahs!;

    try {
      final jsonString = await rootBundle.loadString('assets/data/quran.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedSurahs = jsonList.map((item) => Surah.fromJson(item as Map<String, dynamic>)).toList();
      return _cachedSurahs!;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Surah?> getSurahByNumber(int number) async {
    final surahs = await getAllSurahs();
    return surahs.cast<Surah?>().firstWhere(
          (s) => s?.number == number,
          orElse: () => null,
        );
  }

  @override
  Future<List<Surah>> searchSurahs(String query) async {
    final surahs = await getAllSurahs();
    if (query.trim().isEmpty) return surahs;

    final cleanQuery = _normalizeArabic(query.trim());
    return surahs.where((s) {
      final cleanName = _normalizeArabic(s.nameAr);
      final cleanTrans = s.transliteration.toLowerCase();
      final cleanEn = s.nameEn.toLowerCase();
      final qLower = query.toLowerCase();

      return cleanName.contains(cleanQuery) ||
          cleanTrans.contains(qLower) ||
          cleanEn.contains(qLower) ||
          s.number.toString() == query.trim();
    }).toList();
  }

  @override
  Future<List<JuzItem>> getJuzList() async {
    final surahs = await getAllSurahs();
    final List<JuzItem> juzList = [];
    final Map<int, JuzItem> foundJuz = {};

    for (final surah in surahs) {
      for (final verse in surah.verses) {
        if (!foundJuz.containsKey(verse.juz)) {
          final item = JuzItem(
            juzNumber: verse.juz,
            startSurahName: surah.nameAr,
            startVerseNumber: verse.number,
            pageNumber: verse.page,
          );
          foundJuz[verse.juz] = item;
          juzList.add(item);
        }
      }
    }

    juzList.sort((a, b) => a.juzNumber.compareTo(b.juzNumber));
    return juzList;
  }

  @override
  Future<Verse?> getRandomVerse() async {
    final surahs = await getAllSurahs();
    if (surahs.isEmpty) return null;
    final random = Random();
    final randomSurah = surahs[random.nextInt(surahs.length)];
    if (randomSurah.verses.isEmpty) return null;
    return randomSurah.verses[random.nextInt(randomSurah.verses.length)];
  }

  @override
  Future<void> saveLastRead({
    required int surahNumber,
    required int verseNumber,
    required int pageNumber,
  }) async {
    await CacheHelper.saveData(key: _keyLastSurah, value: surahNumber);
    await CacheHelper.saveData(key: _keyLastVerse, value: verseNumber);
    await CacheHelper.saveData(key: _keyLastPage, value: pageNumber);
  }

  @override
  Map<String, dynamic>? getLastRead() {
    final surahNum = CacheHelper.getData(key: _keyLastSurah) as int?;
    final verseNum = CacheHelper.getData(key: _keyLastVerse) as int?;
    final pageNum = CacheHelper.getData(key: _keyLastPage) as int?;

    if (surahNum != null) {
      return {
        'surahNumber': surahNum,
        'verseNumber': verseNum ?? 1,
        'pageNumber': pageNum ?? 1,
      };
    }
    return null;
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '') // remove tashkeel
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }
}
