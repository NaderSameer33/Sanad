import 'package:adhan/adhan.dart';
import '../../features/home/data/models/home_models.dart';

enum PrayerPeriodTheme {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
  midnight,
}

class PrayerCalculationResult {
  final List<PrayerTimeItem> prayers;
  final List<PrayerTimeItem> specialTimes;
  final String nextPrayerName;
  final DateTime nextPrayerTime;
  final Duration remainingUntilNext;
  final String currentPeriod;
  final PrayerPeriodTheme prayerPeriodTheme;
  final double qiblaAngle;
  final DateTime midnightTime;
  final DateTime lastThirdTime;
  final DateTime sunriseTime;

  PrayerCalculationResult({
    required this.prayers,
    required this.specialTimes,
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.remainingUntilNext,
    required this.currentPeriod,
    required this.prayerPeriodTheme,
    required this.qiblaAngle,
    required this.midnightTime,
    required this.lastThirdTime,
    required this.sunriseTime,
  });
}

class PrayerTimeService {
  /// Calculate full prayer times, next prayer, remaining countdown, Qibla, midnight & last third
  PrayerCalculationResult calculatePrayers({
    required double latitude,
    required double longitude,
    DateTime? dateTime,
  }) {
    final now = dateTime ?? DateTime.now();
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;

    final dateComponents = DateComponents.from(now);
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    final qibla = Qibla(coordinates);
    final qiblaAngle = qibla.direction;

    // Calculation of Night Times (Midnight & Last Third of Night)
    DateTime maghribForNight;
    DateTime fajrForNight;

    if (now.isBefore(prayerTimes.fajr)) {
      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayPrayerTimes = PrayerTimes(
        coordinates,
        DateComponents.from(yesterday),
        params,
      );
      maghribForNight = yesterdayPrayerTimes.maghrib;
      fajrForNight = prayerTimes.fajr;
    } else {
      maghribForNight = prayerTimes.maghrib;
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowPrayerTimes = PrayerTimes(
        coordinates,
        DateComponents.from(tomorrow),
        params,
      );
      fajrForNight = tomorrowPrayerTimes.fajr;
    }

    final totalNightDuration = fajrForNight.difference(maghribForNight);
    final midnight = maghribForNight.add(Duration(seconds: totalNightDuration.inSeconds ~/ 2));
    final lastThird = maghribForNight.add(Duration(seconds: (totalNightDuration.inSeconds * 2) ~/ 3));

    // Identify next prayer and its time
    final next = prayerTimes.nextPrayer();
    String nextName;
    DateTime nextTime;

    if (next == Prayer.none || next == Prayer.fajr && now.isAfter(prayerTimes.isha)) {
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowPrayerTimes = PrayerTimes(
        coordinates,
        DateComponents.from(tomorrow),
        params,
      );
      nextName = 'الفجر';
      nextTime = tomorrowPrayerTimes.fajr;
    } else {
      switch (next) {
        case Prayer.fajr:
          nextName = 'الفجر';
          nextTime = prayerTimes.fajr;
          break;
        case Prayer.sunrise:
          nextName = 'الشروق';
          nextTime = prayerTimes.sunrise;
          break;
        case Prayer.dhuhr:
          nextName = 'الظهر';
          nextTime = prayerTimes.dhuhr;
          break;
        case Prayer.asr:
          nextName = 'العصر';
          nextTime = prayerTimes.asr;
          break;
        case Prayer.maghrib:
          nextName = 'المغرب';
          nextTime = prayerTimes.maghrib;
          break;
        case Prayer.isha:
          nextName = 'العشاء';
          nextTime = prayerTimes.isha;
          break;
        case Prayer.none:
          nextName = 'الفجر';
          nextTime = prayerTimes.fajr;
          break;
      }
    }

    final remaining = nextTime.difference(now);
    final positiveRemaining = remaining.isNegative ? Duration.zero : remaining;

    // Determine current Islamic period badge & theme
    final currentPeriod = _determineCurrentPeriod(now, prayerTimes, midnight, lastThird);
    final prayerTheme = _determinePrayerTheme(now, prayerTimes, midnight, lastThird);

    // Build the 5 core prayer items
    final prayerItems = [
      PrayerTimeItem(
        name: 'الفجر',
        time: _formatPrayerTime(prayerTimes.fajr),
        isNext: nextName == 'الفجر',
      ),
      PrayerTimeItem(
        name: 'الظهر',
        time: _formatPrayerTime(prayerTimes.dhuhr),
        isNext: nextName == 'الظهر',
      ),
      PrayerTimeItem(
        name: 'العصر',
        time: _formatPrayerTime(prayerTimes.asr),
        isNext: nextName == 'العصر',
      ),
      PrayerTimeItem(
        name: 'المغرب',
        time: _formatPrayerTime(prayerTimes.maghrib),
        isNext: nextName == 'المغرب',
      ),
      PrayerTimeItem(
        name: 'العشاء',
        time: _formatPrayerTime(prayerTimes.isha),
        isNext: nextName == 'العشاء',
      ),
    ];

    // Build special sun & night times: الشروق، منتصف الليل، الثلث الأخير
    final specialItems = [
      PrayerTimeItem(
        name: 'الشروق',
        time: _formatPrayerTime(prayerTimes.sunrise),
        isNext: nextName == 'الشروق',
      ),
      PrayerTimeItem(
        name: 'منتصف الليل',
        time: _formatPrayerTime(midnight),
        isNext: now.isAfter(prayerTimes.isha) && now.isBefore(midnight),
      ),
      PrayerTimeItem(
        name: 'الثلث الأخير',
        time: _formatPrayerTime(lastThird),
        isNext: now.isAfter(midnight) && now.isBefore(lastThird),
      ),
    ];

    return PrayerCalculationResult(
      prayers: prayerItems,
      specialTimes: specialItems,
      nextPrayerName: nextName,
      nextPrayerTime: nextTime,
      remainingUntilNext: positiveRemaining,
      currentPeriod: currentPeriod,
      prayerPeriodTheme: prayerTheme,
      qiblaAngle: qiblaAngle,
      midnightTime: midnight,
      lastThirdTime: lastThird,
      sunriseTime: prayerTimes.sunrise,
    );
  }

  String _determineCurrentPeriod(
    DateTime now,
    PrayerTimes pt,
    DateTime midnight,
    DateTime lastThird,
  ) {
    if (now.isAfter(lastThird) && now.isBefore(pt.fajr)) {
      return 'الثلث الأخير (الأسحار)';
    } else if (now.isAfter(midnight) && now.isBefore(lastThird)) {
      return 'منتصف الليل';
    } else if (now.isBefore(pt.fajr)) {
      return 'قيام الليل';
    } else if (now.isBefore(pt.sunrise)) {
      return 'وقت الفجر';
    } else if (now.isBefore(pt.sunrise.add(const Duration(minutes: 25)))) {
      return 'وقت الشروق';
    } else if (now.isBefore(pt.dhuhr.subtract(const Duration(minutes: 20)))) {
      return 'وقت الضحى';
    } else if (now.isBefore(pt.asr)) {
      return 'وقت الظهر';
    } else if (now.isBefore(pt.maghrib)) {
      return 'وقت العصر';
    } else if (now.isBefore(pt.isha)) {
      return 'وقت المغرب';
    } else {
      return 'وقت العشاء';
    }
  }

  PrayerPeriodTheme _determinePrayerTheme(
    DateTime now,
    PrayerTimes pt,
    DateTime midnight,
    DateTime lastThird,
  ) {
    if (now.isBefore(pt.fajr)) {
      return PrayerPeriodTheme.midnight;
    } else if (now.isBefore(pt.sunrise)) {
      return PrayerPeriodTheme.fajr;
    } else if (now.isBefore(pt.dhuhr.subtract(const Duration(minutes: 15)))) {
      return PrayerPeriodTheme.sunrise;
    } else if (now.isBefore(pt.asr)) {
      return PrayerPeriodTheme.dhuhr;
    } else if (now.isBefore(pt.maghrib)) {
      return PrayerPeriodTheme.asr;
    } else if (now.isBefore(pt.isha)) {
      return PrayerPeriodTheme.maghrib;
    } else if (now.isBefore(midnight)) {
      return PrayerPeriodTheme.isha;
    } else {
      return PrayerPeriodTheme.midnight;
    }
  }

  String _formatPrayerTime(DateTime dt) {
    int hour = dt.hour;
    final isPm = hour >= 12;
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = isPm ? 'م' : 'ص';

    // Convert digits to Arabic-Indic digits
    return _toArabicDigits('$hour:$minute $amPm');
  }

  String _toArabicDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }
    return input;
  }
}
