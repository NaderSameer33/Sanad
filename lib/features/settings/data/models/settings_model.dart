class AppSettingsModel {
  final int hijriAdjustment;
  final String calculationMethod;
  final String madhab;
  final double quranFontSize;
  final bool autoPlayNext;

  const AppSettingsModel({
    this.hijriAdjustment = 0,
    this.calculationMethod = 'egyptian',
    this.madhab = 'shafi',
    this.quranFontSize = 22.0,
    this.autoPlayNext = true,
  });

  AppSettingsModel copyWith({
    int? hijriAdjustment,
    String? calculationMethod,
    String? madhab,
    double? quranFontSize,
    bool? autoPlayNext,
  }) {
    return AppSettingsModel(
      hijriAdjustment: hijriAdjustment ?? this.hijriAdjustment,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
      quranFontSize: quranFontSize ?? this.quranFontSize,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
    );
  }
}
