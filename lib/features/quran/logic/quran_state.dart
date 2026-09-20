import '../data/models/quran_models.dart';

class QuranState {
  final List<Surah> surahs;
  final List<Surah> filteredSurahs;
  final List<JuzItem> juzList;
  final Map<String, dynamic>? lastRead;
  final bool isLoading;
  final int selectedTab; // 0 = Surahs, 1 = Juz
  final String searchQuery;

  const QuranState({
    this.surahs = const [],
    this.filteredSurahs = const [],
    this.juzList = const [],
    this.lastRead,
    this.isLoading = true,
    this.selectedTab = 0,
    this.searchQuery = '',
  });

  QuranState copyWith({
    List<Surah>? surahs,
    List<Surah>? filteredSurahs,
    List<JuzItem>? juzList,
    Map<String, dynamic>? lastRead,
    bool? isLoading,
    int? selectedTab,
    String? searchQuery,
  }) {
    return QuranState(
      surahs: surahs ?? this.surahs,
      filteredSurahs: filteredSurahs ?? this.filteredSurahs,
      juzList: juzList ?? this.juzList,
      lastRead: lastRead ?? this.lastRead,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
