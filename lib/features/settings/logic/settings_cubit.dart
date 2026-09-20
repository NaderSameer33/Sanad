import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/hijri_date_service.dart';
import '../data/repos/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;
  final HijriDateService hijriDateService;

  SettingsCubit({
    required this.repository,
    required this.hijriDateService,
  }) : super(const SettingsState()) {
    loadSettings();
  }

  void loadSettings() {
    final s = repository.getSettings();
    final preview = _getPreview(s.hijriAdjustment);
    emit(state.copyWith(settings: s, formattedHijriPreview: preview));
  }

  Future<void> updateHijriAdjustment(int days) async {
    final updated = state.settings.copyWith(hijriAdjustment: days);
    await repository.saveSettings(updated);
    final preview = _getPreview(days);
    emit(state.copyWith(settings: updated, formattedHijriPreview: preview));
  }

  Future<void> updateCalculationMethod(String method) async {
    final updated = state.settings.copyWith(calculationMethod: method);
    await repository.saveSettings(updated);
    emit(state.copyWith(settings: updated));
  }

  Future<void> updateMadhab(String madhab) async {
    final updated = state.settings.copyWith(madhab: madhab);
    await repository.saveSettings(updated);
    emit(state.copyWith(settings: updated));
  }

  Future<void> updateQuranFontSize(double size) async {
    final updated = state.settings.copyWith(quranFontSize: size);
    await repository.saveSettings(updated);
    emit(state.copyWith(settings: updated));
  }

  String _getPreview(int adjustment) {
    final hijri = hijriDateService.getHijriDate(customAdjustment: adjustment);
    return hijri.toFullDateString();
  }
}
