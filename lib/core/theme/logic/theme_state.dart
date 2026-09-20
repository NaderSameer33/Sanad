import 'package:flutter/material.dart';
import '../../services/prayer_time_service.dart';

class ThemeState {
  final ThemeMode themeMode;
  final PrayerPeriodTheme activePrayerTheme;
  final bool isDynamicThemeEnabled;

  const ThemeState({
    required this.themeMode,
    this.activePrayerTheme = PrayerPeriodTheme.dhuhr,
    this.isDynamicThemeEnabled = true,
  });

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeState copyWith({
    ThemeMode? themeMode,
    PrayerPeriodTheme? activePrayerTheme,
    bool? isDynamicThemeEnabled,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      activePrayerTheme: activePrayerTheme ?? this.activePrayerTheme,
      isDynamicThemeEnabled: isDynamicThemeEnabled ?? this.isDynamicThemeEnabled,
    );
  }
}
