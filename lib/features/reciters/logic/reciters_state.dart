import '../../../../core/services/audio_service.dart';
import '../data/models/reciter_models.dart';

class RecitersState {
  final List<Reciter> reciters;
  final List<Reciter> filteredReciters;
  final bool isLoading;
  final String searchQuery;
  final AudioPlaybackInfo playbackInfo;

  const RecitersState({
    this.reciters = const [],
    this.filteredReciters = const [],
    this.isLoading = true,
    this.searchQuery = '',
    this.playbackInfo = const AudioPlaybackInfo(),
  });

  RecitersState copyWith({
    List<Reciter>? reciters,
    List<Reciter>? filteredReciters,
    bool? isLoading,
    String? searchQuery,
    AudioPlaybackInfo? playbackInfo,
  }) {
    return RecitersState(
      reciters: reciters ?? this.reciters,
      filteredReciters: filteredReciters ?? this.filteredReciters,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      playbackInfo: playbackInfo ?? this.playbackInfo,
    );
  }
}
