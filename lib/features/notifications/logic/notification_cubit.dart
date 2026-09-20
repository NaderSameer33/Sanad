import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/prayer_time_service.dart';
import '../data/models/notification_settings_model.dart';
import '../data/repos/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;
  final NotificationService notificationService;
  final LocationService locationService;
  final PrayerTimeService prayerTimeService;

  NotificationCubit({
    required this.repository,
    required this.notificationService,
    required this.locationService,
    required this.prayerTimeService,
  }) : super(const NotificationState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    final settings = await repository.getSettings();
    emit(state.copyWith(settings: settings, isLoading: false));
    await rescheduleNotifications(settings);
  }

  Future<void> toggleFajr(bool value) async {
    final updated = state.settings.copyWith(fajr: value);
    await _updateSettings(updated);
  }

  Future<void> toggleDhuhr(bool value) async {
    final updated = state.settings.copyWith(dhuhr: value);
    await _updateSettings(updated);
  }

  Future<void> toggleAsr(bool value) async {
    final updated = state.settings.copyWith(asr: value);
    await _updateSettings(updated);
  }

  Future<void> toggleMaghrib(bool value) async {
    final updated = state.settings.copyWith(maghrib: value);
    await _updateSettings(updated);
  }

  Future<void> toggleIsha(bool value) async {
    final updated = state.settings.copyWith(isha: value);
    await _updateSettings(updated);
  }

  Future<void> toggleMorningAthkar(bool value) async {
    final updated = state.settings.copyWith(morningAthkar: value);
    await _updateSettings(updated);
  }

  Future<void> toggleEveningAthkar(bool value) async {
    final updated = state.settings.copyWith(eveningAthkar: value);
    await _updateSettings(updated);
  }

  Future<void> toggleFridayKahf(bool value) async {
    final updated = state.settings.copyWith(fridayKahf: value);
    await _updateSettings(updated);
  }

  Future<void> changeSoundType(String type) async {
    final updated = state.settings.copyWith(soundType: type);
    await _updateSettings(updated);
  }

  Future<void> _updateSettings(NotificationSettings settings) async {
    emit(state.copyWith(settings: settings));
    await repository.saveSettings(settings);
    await rescheduleNotifications(settings);
  }

  Future<void> sendTestNotification() async {
    await notificationService.showInstantNotification(
      id: 999,
      title: 'سَنَد - حان الآن موعد الصلاة 🕌',
      body: 'حي على الصلاة، حي على الفلاح.. بارك الله فيك ونفع بك.',
    );
    emit(state.copyWith(testSent: true));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(testSent: false));
  }

  Future<void> rescheduleNotifications(NotificationSettings settings) async {
    try {
      final loc = locationService.getCachedOrDefault();
      final now = DateTime.now();

      // Cancel previous prayer IDs (101 to 105)
      for (int id = 101; id <= 105; id++) {
        await notificationService.cancelNotification(id);
      }

      // Calculate prayer times for today and schedule
      final todayCalc = prayerTimeService.calculatePrayers(
        latitude: loc.latitude,
        longitude: loc.longitude,
        dateTime: now,
      );

      // Fajr
      if (settings.fajr) {
        final fajrTime = _findTimeForPrayer(todayCalc, 'الفجر', now);
        if (fajrTime != null && fajrTime.isAfter(now)) {
          await notificationService.scheduleNotification(
            id: 101,
            title: 'أذان الفجر 🕌',
            body: 'الصلاة خير من النوم، حان الآن موعد صلاة الفجر',
            scheduledDate: fajrTime,
          );
        }
      }

      // Dhuhr
      if (settings.dhuhr) {
        final dhuhrTime = _findTimeForPrayer(todayCalc, 'الظهر', now);
        if (dhuhrTime != null && dhuhrTime.isAfter(now)) {
          await notificationService.scheduleNotification(
            id: 102,
            title: 'أذان الظهر 🕌',
            body: 'حي على الصلاة، حي على الفلاح.. حان الآن موعد صلاة الظهر',
            scheduledDate: dhuhrTime,
          );
        }
      }

      // Asr
      if (settings.asr) {
        final asrTime = _findTimeForPrayer(todayCalc, 'العصر', now);
        if (asrTime != null && asrTime.isAfter(now)) {
          await notificationService.scheduleNotification(
            id: 103,
            title: 'أذان العصر 🕌',
            body: 'حافظوا على الصلوات والصلاة الوسطى.. حان موعد صلاة العصر',
            scheduledDate: asrTime,
          );
        }
      }

      // Maghrib
      if (settings.maghrib) {
        final maghribTime = _findTimeForPrayer(todayCalc, 'المغرب', now);
        if (maghribTime != null && maghribTime.isAfter(now)) {
          await notificationService.scheduleNotification(
            id: 104,
            title: 'أذان المغرب 🕌',
            body: 'اللهم هذا إقبال ليلك وإدبار نهارك.. حان موعد صلاة المغرب',
            scheduledDate: maghribTime,
          );
        }
      }

      // Isha
      if (settings.isha) {
        final ishaTime = _findTimeForPrayer(todayCalc, 'العشاء', now);
        if (ishaTime != null && ishaTime.isAfter(now)) {
          await notificationService.scheduleNotification(
            id: 105,
            title: 'أذان العشاء 🕌',
            body: 'حي على الصلاة، حي على الفلاح.. حان موعد صلاة العشاء',
            scheduledDate: ishaTime,
          );
        }
      }

      // Morning Athkar (e.g., today at 07:00 AM or tomorrow)
      if (settings.morningAthkar) {
        DateTime morningTarget = DateTime(now.year, now.month, now.day, 7, 0);
        if (morningTarget.isBefore(now)) {
          morningTarget = morningTarget.add(const Duration(days: 1));
        }
        await notificationService.scheduleNotification(
          id: 201,
          title: 'أذكار الصباح ☀️',
          body: 'أصبحنا وأصبح الملك لله، لا تنسَ قراءة أذكار الصباح لحفظك ويومك المبارك.',
          scheduledDate: morningTarget,
        );
      }

      // Evening Athkar (e.g., today at 17:00 PM or tomorrow)
      if (settings.eveningAthkar) {
        DateTime eveningTarget = DateTime(now.year, now.month, now.day, 17, 0);
        if (eveningTarget.isBefore(now)) {
          eveningTarget = eveningTarget.add(const Duration(days: 1));
        }
        await notificationService.scheduleNotification(
          id: 202,
          title: 'أذكار المساء 🌙',
          body: 'أمسينا وأمسى الملك لله، حصّن نفسك بأذكار المساء وطمأنينة القلب.',
          scheduledDate: eveningTarget,
        );
      }
    } catch (e) {
      // Ignored if background schedule fails
    }
  }

  DateTime? _findTimeForPrayer(PrayerCalculationResult calc, String name, DateTime now) {
    if (calc.nextPrayerName == name) {
      return calc.nextPrayerTime;
    }
    return null;
  }
}
