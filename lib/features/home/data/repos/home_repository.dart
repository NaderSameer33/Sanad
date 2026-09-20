import '../../../../core/services/hijri_date_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/prayer_time_service.dart';
import '../../../athkar/data/repos/athkar_repository.dart';
import '../../../quran/data/repos/quran_repository.dart';
import '../models/home_models.dart';

class HomeRepository {
  final LocationService locationService;
  final PrayerTimeService prayerTimeService;
  final QuranRepository quranRepository;
  final AthkarRepository athkarRepository;
  final HijriDateService hijriDateService;

  const HomeRepository({
    required this.locationService,
    required this.prayerTimeService,
    required this.quranRepository,
    required this.athkarRepository,
    required this.hijriDateService,
  });

  Future<UserLocation> getUserLocation() async {
    return await locationService.determinePosition();
  }

  PrayerCalculationResult getPrayerCalculations({
    required double latitude,
    required double longitude,
  }) {
    return prayerTimeService.calculatePrayers(
      latitude: latitude,
      longitude: longitude,
    );
  }

  String getHijriDateString() {
    final hijri = hijriDateService.getHijriDate();
    return hijri.toFullDateString();
  }

  Future<VerseOfDay> getVerseOfDay() async {
    final now = DateTime.now();
    // Daily curated Quran verses with authentic Arabic Tafsir
    final List<VerseOfDay> curatedVerses = [
      const VerseOfDay(
        surahName: 'سورة الشرح',
        ayahNumber: 6,
        arabicText: '«إِنَّ مَعَ الْعُسْرِ يُسْرًا» ۝',
        tafsirSource: 'تفسير السعدي الميسر:',
        tafsirText:
            'بشارة عظيمة، أنه كلما وجد عسر ومشقة، فإن الفرج ملازم له ومعية اليسر تتبعه، فلن يغلب عسر يسرين.',
      ),
      const VerseOfDay(
        surahName: 'سورة البقرة',
        ayahNumber: 186,
        arabicText: '«وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ» ۝',
        tafsirSource: 'تفسير ابن كثير الميسر:',
        tafsirText:
            'إخبار من الله تعالى أنه قريب من عباده، يسمع دعاءهم ويجيب سؤالهم، ولا يخيب من رجاه وأقبل عليه مخلصاً.',
      ),
      const VerseOfDay(
        surahName: 'سورة الزمر',
        ayahNumber: 53,
        arabicText: '«قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَى أَنْفُسِهِمْ لَا تَقْنَطُوا مِنْ رَحْمَةِ اللَّهِ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا» ۝',
        tafsirSource: 'التفسير الميسر:',
        tafsirText:
            'دعوة كريمة من أرحم الراحمين لجميع العصاة بالتوبة والإنابة، والإخبار بأنه يغفر الخطايا كلها لمن تاب ولا يقنط من رحمة ربه.',
      ),
      const VerseOfDay(
        surahName: 'سورة الطلاق',
        ayahNumber: 3,
        arabicText: '«وَمَنْ يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ إِنَّ اللَّهَ بَالِغُ أَمْرِهِ» ۝',
        tafsirSource: 'تفسير السعدي:',
        tafsirText:
            'من فوض أمره إلى الله وتوكل عليه كفاه ما أهمه في أمر دينه ودنياه، ورزقه من حيث لا يخطر له على بال.',
      ),
      const VerseOfDay(
        surahName: 'سورة الرحمن',
        ayahNumber: 13,
        arabicText: '«فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ» ۝',
        tafsirSource: 'التفسير الميسر:',
        tafsirText:
            'فبأي نعم ربكم الدينية والدنيوية الجليلة تكذبان يا معشر الإنس والجن؟ وكل نعمة تتقلبون فيها فمن فضله وجوده.',
      ),
      const VerseOfDay(
        surahName: 'سورة الأنبياء',
        ayahNumber: 87,
        arabicText: '«لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ» ۝',
        tafsirSource: 'تفسير القرطبي:',
        tafsirText:
            'دعوة يونس عليه السلام في بطن الحوت؛ توحيد وتسبيح واعتراف بالذنب، ما دعا بها مكروب إلا كشف الله كربه وأبدل خوفه أمناً.',
      ),
      const VerseOfDay(
        surahName: 'سورة البقرة',
        ayahNumber: 286,
        arabicText: '«لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا» ۝',
        tafsirSource: 'تفسير السعدي:',
        tafsirText:
            'من عدل الله ورحمته ولطفه أنه لا يكلف نفساً إلا ما تطيقه ولا يشق عليها، ورفع الحرج والمشقة عن هذه الأمة المرحومة.',
      ),
    ];

    final dayIndex = (now.day + now.month) % curatedVerses.length;
    return curatedVerses[dayIndex];
  }

  Future<WirdProgress> getWirdProgress() async {
    final eveningAthkar = await athkarRepository.getAthkarByCategory('أذكار المساء');
    final total = eveningAthkar.isNotEmpty ? eveningAthkar.length : 25;
    final savedCompleted = await athkarRepository.getSavedCounter('evening_completed');

    final nextDhikr = eveningAthkar.isNotEmpty
        ? '«${eveningAthkar.first.content.length > 40 ? "${eveningAthkar.first.content.substring(0, 40)}..." : eveningAthkar.first.content}»'
        : '«أمسينا وأمسى الملك لله، والحمد لله...»';

    return WirdProgress(
      title: 'أذكار المساء',
      completedCount: savedCompleted > 0 ? (savedCompleted > total ? total : savedCompleted) : 13,
      totalCount: total,
      nextDhikr: nextDhikr,
    );
  }
}
