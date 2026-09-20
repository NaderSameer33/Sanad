import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/di.dart';
import '../../../../core/theme/logic/theme_cubit.dart';
import '../data/models/home_models.dart';
import '../data/repos/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;
  Timer? _countdownTimer;
  DateTime? _nextPrayerTargetTime;
  double _currentLat = 30.0444;
  double _currentLng = 31.2357;

  HomeCubit(this._repository)
      : super(
          HomeState(
            prayerTimes: const [
              PrayerTimeItem(name: 'الفجر', time: '٤:٣٠ ص', isPassed: true),
              PrayerTimeItem(name: 'الظهر', time: '١٢:٠٥ م', isPassed: true),
              PrayerTimeItem(name: 'العصر', time: '٣:٢٥ م', isPassed: true),
              PrayerTimeItem(name: 'المغرب', time: '٥:٥٠ م', isPassed: true),
              PrayerTimeItem(name: 'العشاء', time: '٧:١٥ م', isNext: true),
            ],
            nextPrayerName: 'صلاة العشاء',
            remainingTime: '٠٠:٣٥:١٢',
            verseOfDay: const VerseOfDay(
              surahName: 'سورة الشرح',
              ayahNumber: 6,
              arabicText: '«إِنَّ مَعَ الْعُسْرِ يُسْرًا» ۝',
              tafsirSource: 'تفسير السعدي:',
              tafsirText:
                  'بشارة عظيمة، أنه كلما وجد عسر ومشقة، فإن الفرج ملازم له ومعية اليسر تتبعه، فلن يغلب عسر يسرين.',
            ),
            wirdProgress: const WirdProgress(
              title: 'أذكار المساء',
              completedCount: 13,
              totalCount: 20,
              nextDhikr: '«أمسينا وأمسى الملك لله، والحمد لله...»',
            ),
            location: 'القاهرة، مصر',
            hijriDate: _repository.getHijriDateString(),
            timeSlot: 'وقت الضحى',
            greeting: 'طابَ يومُكَ بالذِّكر والطَّاعة',
            qiblaAngle: 245.0,
          ),
        ) {
    initializeHome();
  }

  Future<void> initializeHome() async {
    try {
      // 1. Fetch user location
      final userLoc = await _repository.getUserLocation();
      _currentLat = userLoc.latitude;
      _currentLng = userLoc.longitude;

      // 2. Calculate prayer times for this location
      _calculateAndApplyPrayers(userLoc.displayName);

      // 3. Load verse of day and wird progress
      final verse = await _repository.getVerseOfDay();
      final wird = await _repository.getWirdProgress();

      emit(
        state.copyWith(
          verseOfDay: verse,
          wirdProgress: wird,
        ),
      );
    } catch (_) {
      // Keep default fallback if location fails
    }
  }

  void _calculateAndApplyPrayers(String locationName) {
    final result = _repository.getPrayerCalculations(
      latitude: _currentLat,
      longitude: _currentLng,
    );

    _nextPrayerTargetTime = result.nextPrayerTime;

    emit(
      state.copyWith(
        prayerTimes: result.prayers,
        specialTimes: result.specialTimes,
        nextPrayerName: 'صلاة ${result.nextPrayerName}',
        location: locationName,
        hijriDate: _repository.getHijriDateString(),
        timeSlot: result.currentPeriod,
        qiblaAngle: result.qiblaAngle,
        prayerPeriodTheme: result.prayerPeriodTheme,
      ),
    );

    // Sync theme dynamically with prayer period
    if (getIt.isRegistered<ThemeCubit>()) {
      getIt<ThemeCubit>().updateDynamicPrayerPeriod(result.prayerPeriodTheme);
    }

    _startLiveTimer();
  }

  void _startLiveTimer() {
    _countdownTimer?.cancel();

    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_nextPrayerTargetTime == null) return;

    final now = DateTime.now();
    final difference = _nextPrayerTargetTime!.difference(now);

    if (difference.isNegative || difference.inSeconds <= 0) {
      // Target reached, recalculate next prayer
      _calculateAndApplyPrayers(state.location);
      return;
    }

    final hours = difference.inHours;
    final minutes = (difference.inMinutes % 60);
    final seconds = (difference.inSeconds % 60);

    final formatted =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    emit(state.copyWith(remainingTime: _toArabicDigits(formatted)));
  }

  void toggleTafsirExpanded() {
    emit(state.copyWith(isTafsirExpanded: !state.isTafsirExpanded));
  }

  Future<void> refreshHomeData() async {
    await initializeHome();
  }

  String _toArabicDigits(String input) {
    const englishToArabic = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    return input.split('').map((c) => englishToArabic[c] ?? c).join('');
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
