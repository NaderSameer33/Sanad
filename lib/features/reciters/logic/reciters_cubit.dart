import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/audio_service.dart';
import '../data/models/reciter_models.dart';
import '../data/repos/reciters_repository.dart';
import 'reciters_state.dart';

class RecitersCubit extends Cubit<RecitersState> {
  final RecitersRepository _repository;
  final AudioService _audioService;
  StreamSubscription<AudioPlaybackInfo>? _audioSub;

  RecitersCubit(this._repository, this._audioService) : super(const RecitersState()) {
    _init();
  }

  void _init() {
    loadReciters();

    _audioSub = _audioService.playbackStream.listen((info) {
      emit(state.copyWith(playbackInfo: info));
    });
  }

  Future<void> loadReciters() async {
    emit(state.copyWith(isLoading: true));
    try {
      final reciters = await _repository.getAllReciters();
      emit(
        state.copyWith(
          reciters: reciters,
          filteredReciters: reciters,
          isLoading: false,
          playbackInfo: _audioService.currentInfo,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      emit(state.copyWith(filteredReciters: state.reciters, searchQuery: ''));
      return;
    }

    final cleanQuery = _normalizeArabic(query.trim());
    final filtered = state.reciters.where((r) {
      final cleanName = _normalizeArabic(r.name);
      return cleanName.contains(cleanQuery);
    }).toList();

    emit(state.copyWith(filteredReciters: filtered, searchQuery: query));
  }

  Future<void> playSurah({
    required Reciter reciter,
    required MoshafInfo moshaf,
    required int surahNumber,
    required String surahName,
  }) async {
    final url = moshaf.getSurahAudioUrl(surahNumber);
    await _audioService.playAudio(
      url: url,
      title: 'سورة $surahName',
      subTitle: '${reciter.name} (${moshaf.name})',
    );
  }

  Future<void> togglePlayPause() async {
    await _audioService.togglePlayPause();
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> stopAudio() async {
    await _audioService.stop();
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

  @override
  Future<void> close() {
    _audioSub?.cancel();
    return super.close();
  }
}
