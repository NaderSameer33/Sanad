import '../../../../core/services/cache_service.dart';
import '../models/settings_model.dart';

class SettingsRepository {
  static const String _keyHijriAdj = 'hijri_adjustment_days';
  static const String _keyCalcMethod = 'calc_method';
  static const String _keyMadhab = 'prayer_madhab';
  static const String _keyFontSize = 'quran_font_size';
  static const String _keyAutoPlay = 'auto_play_next';

  AppSettingsModel getSettings() {
    return AppSettingsModel(
      hijriAdjustment: (CacheHelper.getData(key: _keyHijriAdj) as int?) ?? 0,
      calculationMethod: (CacheHelper.getData(key: _keyCalcMethod) as String?) ?? 'egyptian',
      madhab: (CacheHelper.getData(key: _keyMadhab) as String?) ?? 'shafi',
      quranFontSize: _parseDouble(CacheHelper.getData(key: _keyFontSize)) ?? 22.0,
      autoPlayNext: (CacheHelper.getData(key: _keyAutoPlay) as bool?) ?? true,
    );
  }

  Future<void> saveSettings(AppSettingsModel settings) async {
    await CacheHelper.saveData(key: _keyHijriAdj, value: settings.hijriAdjustment);
    await CacheHelper.saveData(key: _keyCalcMethod, value: settings.calculationMethod);
    await CacheHelper.saveData(key: _keyMadhab, value: settings.madhab);
    await CacheHelper.saveData(key: _keyFontSize, value: settings.quranFontSize);
    await CacheHelper.saveData(key: _keyAutoPlay, value: settings.autoPlayNext);
  }

  double? _parseDouble(dynamic val) {
    if (val is double) return val;
    if (val is int) return val.toDouble();
    return null;
  }
}
