import 'cache_service.dart';

class HijriDate {
  final int year;
  final int month;
  final int day;
  final String dayName;
  final String monthName;

  const HijriDate({
    required this.year,
    required this.month,
    required this.day,
    required this.dayName,
    required this.monthName,
  });

  String toFullDateString() {
    return '$dayName، ${_toArabic(day)} $monthName ${_toArabic(year)} هـ';
  }

  String toShortDateString() {
    return '${_toArabic(day)} $monthName ${_toArabic(year)} هـ';
  }

  static String _toArabic(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String res = number.toString();
    for (int i = 0; i < english.length; i++) {
      res = res.replaceAll(english[i], arabic[i]);
    }
    return res;
  }
}

class HijriDateService {
  static const String keyAdjustment = 'hijri_adjustment_days';

  static const List<String> hijriMonths = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  static const List<String> arabicWeekdays = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  const HijriDateService();

  int getSavedAdjustment() {
    final val = CacheHelper.getData(key: keyAdjustment);
    if (val is int) return val;
    return 0;
  }

  Future<void> saveAdjustment(int days) async {
    await CacheHelper.saveData(key: keyAdjustment, value: days);
  }

  HijriDate getHijriDate({DateTime? dateTime, int? customAdjustment}) {
    DateTime now = dateTime ?? DateTime.now();
    final adjustment = customAdjustment ?? getSavedAdjustment();

    if (adjustment != 0) {
      now = now.add(Duration(days: adjustment));
    }

    final dayName = arabicWeekdays[now.weekday - 1];

    // Astronomical calculation (Umm al-Qura / Tabular algorithm)
    int year = now.year;
    int month = now.month;
    int day = now.day;

    // Julian day calculation
    if (month < 3) {
      year -= 1;
      month += 12;
    }

    final a = (year / 100).floor();
    final b = 2 - a + (a / 4).floor();
    final jd = (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524.5;

    final l = (jd - 1948440 + 10632).floor();
    final n = ((l - 1) / 10631).floor();
    final l2 = l - 10631 * n + 354;
    final j = ((10985 - l2) / 5316).floor() * ((50 * l2) / 17719).floor() +
        (l2 / 5670).floor() * ((43 * l2) / 15238).floor();
    final l3 = l2 -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    int hMonth = ((24 * l3) / 709).floor();
    int hDay = (l3 - ((709 * hMonth) / 24).floor());
    int hYear = (30 * n + j - 30);

    if (hMonth < 1) hMonth = 1;
    if (hMonth > 12) hMonth = 12;
    if (hDay < 1) hDay = 1;
    if (hDay > 30) hDay = 30;

    final monthName = hijriMonths[hMonth - 1];

    return HijriDate(
      year: hYear,
      month: hMonth,
      day: hDay,
      dayName: dayName,
      monthName: monthName,
    );
  }
}
