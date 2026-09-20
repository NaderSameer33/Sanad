import '../data/models/settings_model.dart';

class SettingsState {
  final AppSettingsModel settings;
  final String formattedHijriPreview;

  const SettingsState({
    this.settings = const AppSettingsModel(),
    this.formattedHijriPreview = '',
  });

  SettingsState copyWith({
    AppSettingsModel? settings,
    String? formattedHijriPreview,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      formattedHijriPreview: formattedHijriPreview ?? this.formattedHijriPreview,
    );
  }
}
