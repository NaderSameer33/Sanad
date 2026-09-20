import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/cache_service.dart';
import '../../services/prayer_time_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme_mode';
  static const String _dynamicThemeKey = 'app_dynamic_prayer_theme';
  static const String _prayerThemePeriodKey = 'app_active_prayer_period';

  ThemeCubit() : super(_getInitialTheme());

  static ThemeState _getInitialTheme() {
    final savedTheme = CacheHelper.getString(key: _themeKey);
    final savedDynamic = CacheHelper.getData(key: _dynamicThemeKey);
    final isDynamic = savedDynamic is bool ? savedDynamic : true;
    final savedPeriodName = CacheHelper.getString(key: _prayerThemePeriodKey);

    PrayerPeriodTheme period = PrayerPeriodTheme.dhuhr;
    if (savedPeriodName != null) {
      for (final p in PrayerPeriodTheme.values) {
        if (p.name == savedPeriodName) {
          period = p;
          break;
        }
      }
    }

    final mode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    return ThemeState(
      themeMode: mode,
      activePrayerTheme: period,
      isDynamicThemeEnabled: isDynamic,
    );
  }

  Future<void> toggleTheme() async {
    final newMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: newMode));
    await CacheHelper.saveData(
      key: _themeKey,
      value: newMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await CacheHelper.saveData(
      key: _themeKey,
      value: mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  void updateDynamicPrayerPeriod(PrayerPeriodTheme period) {
    if (!state.isDynamicThemeEnabled) return;
    if (state.activePrayerTheme == period) return;
    emit(state.copyWith(activePrayerTheme: period));
  }

  Future<void> setPrayerPeriodTheme(PrayerPeriodTheme period) async {
    emit(state.copyWith(activePrayerTheme: period));
    await CacheHelper.saveData(
      key: _prayerThemePeriodKey,
      value: period.name,
    );
  }

  Future<void> toggleDynamicTheme(bool enabled) async {
    emit(state.copyWith(isDynamicThemeEnabled: enabled));
    await CacheHelper.saveData(
      key: _dynamicThemeKey,
      value: enabled,
    );
  }
}
