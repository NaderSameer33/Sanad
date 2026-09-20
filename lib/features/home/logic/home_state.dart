import '../../../../core/services/prayer_time_service.dart';
import '../data/models/home_models.dart';

class HomeState {
  final List<PrayerTimeItem> prayerTimes;
  final List<PrayerTimeItem> specialTimes;
  final String nextPrayerName;
  final String remainingTime;
  final VerseOfDay verseOfDay;
  final WirdProgress wirdProgress;
  final String location;
  final String hijriDate;
  final String timeSlot;
  final String greeting;
  final bool isTafsirExpanded;
  final double qiblaAngle;
  final PrayerPeriodTheme prayerPeriodTheme;

  const HomeState({
    required this.prayerTimes,
    this.specialTimes = const [],
    required this.nextPrayerName,
    required this.remainingTime,
    required this.verseOfDay,
    required this.wirdProgress,
    required this.location,
    required this.hijriDate,
    required this.timeSlot,
    required this.greeting,
    this.isTafsirExpanded = false,
    this.qiblaAngle = 245.0,
    this.prayerPeriodTheme = PrayerPeriodTheme.dhuhr,
  });

  HomeState copyWith({
    List<PrayerTimeItem>? prayerTimes,
    List<PrayerTimeItem>? specialTimes,
    String? nextPrayerName,
    String? remainingTime,
    VerseOfDay? verseOfDay,
    WirdProgress? wirdProgress,
    String? location,
    String? hijriDate,
    String? timeSlot,
    String? greeting,
    bool? isTafsirExpanded,
    double? qiblaAngle,
    PrayerPeriodTheme? prayerPeriodTheme,
  }) {
    return HomeState(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      specialTimes: specialTimes ?? this.specialTimes,
      nextPrayerName: nextPrayerName ?? this.nextPrayerName,
      remainingTime: remainingTime ?? this.remainingTime,
      verseOfDay: verseOfDay ?? this.verseOfDay,
      wirdProgress: wirdProgress ?? this.wirdProgress,
      location: location ?? this.location,
      hijriDate: hijriDate ?? this.hijriDate,
      timeSlot: timeSlot ?? this.timeSlot,
      greeting: greeting ?? this.greeting,
      isTafsirExpanded: isTafsirExpanded ?? this.isTafsirExpanded,
      qiblaAngle: qiblaAngle ?? this.qiblaAngle,
      prayerPeriodTheme: prayerPeriodTheme ?? this.prayerPeriodTheme,
    );
  }
}
