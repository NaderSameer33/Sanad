import '../data/models/athkar_models.dart';

class AthkarState {
  final List<String> categories;
  final Map<String, List<ThikrItem>> allAthkar;
  final bool isLoading;
  final int selectedTab; // 0 = Categories, 1 = Smart Tasbeeh
  final int tasbeehCount;
  final int selectedTasbeehDhikrIndex;

  const AthkarState({
    this.categories = const [],
    this.allAthkar = const {},
    this.isLoading = true,
    this.selectedTab = 0,
    this.tasbeehCount = 0,
    this.selectedTasbeehDhikrIndex = 0,
  });

  AthkarState copyWith({
    List<String>? categories,
    Map<String, List<ThikrItem>>? allAthkar,
    bool? isLoading,
    int? selectedTab,
    int? tasbeehCount,
    int? selectedTasbeehDhikrIndex,
  }) {
    return AthkarState(
      categories: categories ?? this.categories,
      allAthkar: allAthkar ?? this.allAthkar,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      tasbeehCount: tasbeehCount ?? this.tasbeehCount,
      selectedTasbeehDhikrIndex:
          selectedTasbeehDhikrIndex ?? this.selectedTasbeehDhikrIndex,
    );
  }
}
