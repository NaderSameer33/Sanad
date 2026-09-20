import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/athkar_repository.dart';
import 'athkar_state.dart';

class AthkarCubit extends Cubit<AthkarState> {
  final AthkarRepository _repository;

  static const List<String> tasbeehPhrases = [
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    'الْحَمْدُ لِلَّهِ',
    'لا إِلَهَ إِلا اللَّهُ',
    'اللَّهُ أَكْبَرُ',
    'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
    'لا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ',
    'سُبْحَانَ اللَّهِ الْعَظِيمِ',
    'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
  ];

  AthkarCubit(this._repository) : super(const AthkarState()) {
    loadAthkar();
  }

  Future<void> loadAthkar() async {
    emit(state.copyWith(isLoading: true));
    try {
      final all = await _repository.getAllAthkar();
      final categories = all.keys.toList();
      final savedTasbeeh = await _repository.getSavedCounter('tasbeeh_total');

      emit(
        state.copyWith(
          categories: categories,
          allAthkar: all,
          tasbeehCount: savedTasbeeh,
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void switchTab(int index) {
    emit(state.copyWith(selectedTab: index));
  }

  void switchTasbeehDhikr(int index) {
    emit(state.copyWith(selectedTasbeehDhikrIndex: index));
  }

  Future<void> incrementTasbeeh() async {
    HapticFeedback.lightImpact();
    final newCount = state.tasbeehCount + 1;
    emit(state.copyWith(tasbeehCount: newCount));
    await _repository.saveCounter('tasbeeh_total', newCount);
  }

  Future<void> resetTasbeeh() async {
    HapticFeedback.mediumImpact();
    emit(state.copyWith(tasbeehCount: 0));
    await _repository.saveCounter('tasbeeh_total', 0);
  }
}
