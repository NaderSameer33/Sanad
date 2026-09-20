class NotificationSettings {
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;
  final bool morningAthkar;
  final bool eveningAthkar;
  final bool fridayKahf;
  final String soundType; // 'adhan', 'takbeer', 'gentle'

  const NotificationSettings({
    this.fajr = true,
    this.dhuhr = true,
    this.asr = true,
    this.maghrib = true,
    this.isha = true,
    this.morningAthkar = true,
    this.eveningAthkar = true,
    this.fridayKahf = true,
    this.soundType = 'adhan',
  });

  NotificationSettings copyWith({
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
    bool? morningAthkar,
    bool? eveningAthkar,
    bool? fridayKahf,
    String? soundType,
  }) {
    return NotificationSettings(
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      morningAthkar: morningAthkar ?? this.morningAthkar,
      eveningAthkar: eveningAthkar ?? this.eveningAthkar,
      fridayKahf: fridayKahf ?? this.fridayKahf,
      soundType: soundType ?? this.soundType,
    );
  }
}
