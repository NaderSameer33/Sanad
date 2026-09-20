import '../../../../core/services/cache_service.dart';
import '../models/notification_settings_model.dart';

class NotificationRepository {
  static const String _prefix = 'notif_setting_';

  Future<NotificationSettings> getSettings() async {
    return NotificationSettings(
      fajr: (CacheHelper.getData(key: '${_prefix}fajr') as bool?) ?? true,
      dhuhr: (CacheHelper.getData(key: '${_prefix}dhuhr') as bool?) ?? true,
      asr: (CacheHelper.getData(key: '${_prefix}asr') as bool?) ?? true,
      maghrib: (CacheHelper.getData(key: '${_prefix}maghrib') as bool?) ?? true,
      isha: (CacheHelper.getData(key: '${_prefix}isha') as bool?) ?? true,
      morningAthkar: (CacheHelper.getData(key: '${_prefix}morning') as bool?) ?? true,
      eveningAthkar: (CacheHelper.getData(key: '${_prefix}evening') as bool?) ?? true,
      fridayKahf: (CacheHelper.getData(key: '${_prefix}friday') as bool?) ?? true,
      soundType: (CacheHelper.getData(key: '${_prefix}sound') as String?) ?? 'adhan',
    );
  }

  Future<void> saveSettings(NotificationSettings settings) async {
    await CacheHelper.saveData(key: '${_prefix}fajr', value: settings.fajr);
    await CacheHelper.saveData(key: '${_prefix}dhuhr', value: settings.dhuhr);
    await CacheHelper.saveData(key: '${_prefix}asr', value: settings.asr);
    await CacheHelper.saveData(key: '${_prefix}maghrib', value: settings.maghrib);
    await CacheHelper.saveData(key: '${_prefix}isha', value: settings.isha);
    await CacheHelper.saveData(key: '${_prefix}morning', value: settings.morningAthkar);
    await CacheHelper.saveData(key: '${_prefix}evening', value: settings.eveningAthkar);
    await CacheHelper.saveData(key: '${_prefix}friday', value: settings.fridayKahf);
    await CacheHelper.saveData(key: '${_prefix}sound', value: settings.soundType);
  }
}
