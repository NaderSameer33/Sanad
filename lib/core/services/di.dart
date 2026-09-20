import 'package:get_it/get_it.dart';
import '../../features/athkar/data/repos/athkar_repository.dart';
import '../../features/home/data/repos/home_repository.dart';
import '../../features/home/logic/home_cubit.dart';
import '../../features/notifications/data/repos/notification_repository.dart';
import '../../features/quran/data/repos/quran_repository.dart';
import '../../features/reciters/data/repos/reciters_repository.dart';
import '../../features/settings/data/repos/settings_repository.dart';
import '../theme/logic/theme_cubit.dart';
import 'audio_service.dart';
import 'cache_service.dart';
import 'hijri_date_service.dart';
import 'location_service.dart';
import 'notification_service.dart';
import 'prayer_time_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Core Services
  await CacheHelper.init();

  final notifService = NotificationService();
  await notifService.init();
  getIt.registerSingleton<NotificationService>(notifService);

  getIt.registerLazySingleton<LocationService>(() => const LocationService());
  getIt.registerLazySingleton<PrayerTimeService>(() => PrayerTimeService());
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<HijriDateService>(() => const HijriDateService());

  // 2. Repositories
  getIt.registerLazySingleton<QuranRepository>(() => QuranRepositoryImpl());
  getIt.registerLazySingleton<AthkarRepository>(() => AthkarRepositoryImpl());
  getIt.registerLazySingleton<RecitersRepository>(() => RecitersRepositoryImpl());
  getIt.registerLazySingleton<NotificationRepository>(() => NotificationRepository());
  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepository());

  // 3. Theme Cubit
  getIt.registerSingleton<ThemeCubit>(ThemeCubit());

  // 4. Home Feature
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepository(
      locationService: getIt<LocationService>(),
      prayerTimeService: getIt<PrayerTimeService>(),
      quranRepository: getIt<QuranRepository>(),
      athkarRepository: getIt<AthkarRepository>(),
      hijriDateService: getIt<HijriDateService>(),
    ),
  );

  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepository>()));
}
