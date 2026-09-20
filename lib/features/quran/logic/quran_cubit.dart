import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/quran_repository.dart';
import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final QuranRepository _repository;

  QuranCubit(this._repository) : super(const QuranState()) {
    loadQuran();
  }

  Future<void> loadQuran() async {
    emit(state.copyWith(isLoading: true));
    try {
      final surahs = await _repository.getAllSurahs();
      final juzList = await _repository.getJuzList();
      final lastRead = _repository.getLastRead();

      emit(
        state.copyWith(
          surahs: surahs,
          filteredSurahs: surahs,
          juzList: juzList,
          lastRead: lastRead,
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void filterSurahs(String query) {
    if (query.trim().isEmpty) {
      emit(state.copyWith(filteredSurahs: state.surahs, searchQuery: ''));
      return;
    }

    final cleanQuery = _normalizeArabic(query.trim());
    final filtered = state.surahs.where((s) {
      final cleanName = _normalizeArabic(s.nameAr);
      final cleanTrans = s.transliteration.toLowerCase();
      final qLower = query.toLowerCase();
      return cleanName.contains(cleanQuery) ||
          cleanTrans.contains(qLower) ||
          s.number.toString() == query.trim();
    }).toList();

    emit(state.copyWith(filteredSurahs: filtered, searchQuery: query));
  }

  void switchTab(int index) {
    emit(state.copyWith(selectedTab: index));
  }

  Future<void> saveLastRead({
    required int surahNumber,
    required int verseNumber,
    required int pageNumber,
  }) async {
    await _repository.saveLastRead(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      pageNumber: pageNumber,
    );
    final updatedLastRead = _repository.getLastRead();
    emit(state.copyWith(lastRead: updatedLastRead));
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }
}
