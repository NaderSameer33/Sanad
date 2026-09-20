import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/cache_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme_mode';

  ThemeCubit() : super(_getInitialTheme());

  static ThemeState _getInitialTheme() {
    final savedTheme = CacheHelper.getString(key: _themeKey);
    if (savedTheme == 'dark') {
      return const ThemeState(themeMode: ThemeMode.dark);
    }
    return const ThemeState(themeMode: ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final newMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeState(themeMode: newMode));
    await CacheHelper.saveData(
      key: _themeKey,
      value: newMode == ThemeMode.dark ? 'dark' : 'light',
    ); 
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(ThemeState(themeMode: mode));
    await CacheHelper.saveData(
      key: _themeKey,
      value: mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
