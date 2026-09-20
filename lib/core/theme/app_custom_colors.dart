import 'package:flutter/material.dart';
import '../services/prayer_time_service.dart';
import 'app_colors.dart';

class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color navBarBg;
  final Color navActiveBg;
  final Color navActiveContent;
  final Color navInactiveContent;
  final Color navBorder;
  final Color cardBg;
  final Color cardBorder;
  final Color goldAccent;
  final Color quranVerseText;
  final Color badgeBg;
  final Color badgeBorder;
  final Color badgeText;

  const AppCustomColors({
    required this.navBarBg,
    required this.navActiveBg,
    required this.navActiveContent,
    required this.navInactiveContent,
    required this.navBorder,
    required this.cardBg,
    required this.cardBorder,
    required this.goldAccent,
    required this.quranVerseText,
    required this.badgeBg,
    required this.badgeBorder,
    required this.badgeText,
  });

  static const light = AppCustomColors(
    navBarBg: Colors.white,
    navActiveBg: AppColors.primary,
    navActiveContent: Colors.white,
    navInactiveContent: AppColors.lightTextSecondary,
    navBorder: AppColors.lightBorder,
    cardBg: AppColors.lightSurface,
    cardBorder: AppColors.lightBorder,
    goldAccent: AppColors.gold,
    quranVerseText: AppColors.primary,
    badgeBg: Color(0x1423422A),
    badgeBorder: Color(0x2623422A),
    badgeText: AppColors.primary,
  );

  static const dark = AppCustomColors(
    navBarBg: Color(0xFF16231C),
    navActiveBg: Color(0xFF324D39),
    navActiveContent: Color(0xFFEEF2ED),
    navInactiveContent: Color(0xFFC1C8BF),
    navBorder: AppColors.darkBorder,
    cardBg: AppColors.darkSurface,
    cardBorder: AppColors.darkBorder,
    goldAccent: AppColors.goldLight,
    quranVerseText: AppColors.mintGreen,
    badgeBg: Color(0x0DFFFFFF),
    badgeBorder: AppColors.darkBorder,
    badgeText: Color(0xFFC1C8BF),
  );

  /// Factory for dynamic prayer themes
  static AppCustomColors forPeriod({
    required bool isDark,
    required PrayerPeriodTheme period,
  }) {
    if (isDark) {
      switch (period) {
        case PrayerPeriodTheme.fajr:
          return const AppCustomColors(
            navBarBg: Color(0xFF0A1A20),
            navActiveBg: Color(0xFF1B4953),
            navActiveContent: Color(0xFFCCFBF1),
            navInactiveContent: Color(0xFF94A3B8),
            navBorder: Color(0xFF1E3A44),
            cardBg: Color(0xFF10262E),
            cardBorder: Color(0xFF1E424E),
            goldAccent: Color(0xFF5EEAD4),
            quranVerseText: Color(0xFF99F6E4),
            badgeBg: Color(0x2614B8A6),
            badgeBorder: Color(0x4D14B8A6),
            badgeText: Color(0xFF5EEAD4),
          );
        case PrayerPeriodTheme.sunrise:
          return const AppCustomColors(
            navBarBg: Color(0xFF181510),
            navActiveBg: Color(0xFF452D12),
            navActiveContent: Color(0xFFFEF3C7),
            navInactiveContent: Color(0xFFA8A29E),
            navBorder: Color(0xFF33291C),
            cardBg: Color(0xFF241E15),
            cardBorder: Color(0xFF3E311F),
            goldAccent: Color(0xFFFBBF24),
            quranVerseText: Color(0xFFFDE68A),
            badgeBg: Color(0x26F59E0B),
            badgeBorder: Color(0x4DF59E0B),
            badgeText: Color(0xFFFBBF24),
          );
        case PrayerPeriodTheme.dhuhr:
          return dark;
        case PrayerPeriodTheme.asr:
          return const AppCustomColors(
            navBarBg: Color(0xFF1A130E),
            navActiveBg: Color(0xFF432010),
            navActiveContent: Color(0xFFFFEDD5),
            navInactiveContent: Color(0xFFA8A29E),
            navBorder: Color(0xFF3B2316),
            cardBg: Color(0xFF261912),
            cardBorder: Color(0xFF3E2417),
            goldAccent: Color(0xFFFB923C),
            quranVerseText: Color(0xFFFED7AA),
            badgeBg: Color(0x26EA580C),
            badgeBorder: Color(0x4DEA580C),
            badgeText: Color(0xFFFB923C),
          );
        case PrayerPeriodTheme.maghrib:
          return const AppCustomColors(
            navBarBg: Color(0xFF170D21),
            navActiveBg: Color(0xFF3B1A53),
            navActiveContent: Color(0xFFF3E8FF),
            navInactiveContent: Color(0xFFA1A1AA),
            navBorder: Color(0xFF351C47),
            cardBg: Color(0xFF241233),
            cardBorder: Color(0xFF3B1D54),
            goldAccent: Color(0xFFE879F9),
            quranVerseText: Color(0xFFF0ABFC),
            badgeBg: Color(0x26C026D3),
            badgeBorder: Color(0x4DC026D3),
            badgeText: Color(0xFFE879F9),
          );
        case PrayerPeriodTheme.isha:
          return const AppCustomColors(
            navBarBg: Color(0xFF0B1120),
            navActiveBg: Color(0xFF1E335A),
            navActiveContent: Color(0xFFDBEAFE),
            navInactiveContent: Color(0xFF94A3B8),
            navBorder: Color(0xFF1E2E4E),
            cardBg: Color(0xFF111C34),
            cardBorder: Color(0xFF1E3159),
            goldAccent: Color(0xFF60A5FA),
            quranVerseText: Color(0xFFBFDBFE),
            badgeBg: Color(0x263B82F6),
            badgeBorder: Color(0x4D3B82F6),
            badgeText: Color(0xFF93C5FD),
          );
        case PrayerPeriodTheme.midnight:
          return const AppCustomColors(
            navBarBg: Color(0xFF060911),
            navActiveBg: Color(0xFF16213B),
            navActiveContent: Color(0xFFE2E8F0),
            navInactiveContent: Color(0xFF94A3B8),
            navBorder: Color(0xFF161E30),
            cardBg: Color(0xFF0D1424),
            cardBorder: Color(0xFF18233C),
            goldAccent: Color(0xFFFCD34D),
            quranVerseText: Color(0xFFF8FAFC),
            badgeBg: Color(0x26FCD34D),
            badgeBorder: Color(0x4DFCD34D),
            badgeText: Color(0xFFFDE68A),
          );
      }
    } else {
      // Light Mode for Periods
      switch (period) {
        case PrayerPeriodTheme.fajr:
          return const AppCustomColors(
            navBarBg: Colors.white,
            navActiveBg: Color(0xFF165B65),
            navActiveContent: Colors.white,
            navInactiveContent: Color(0xFF64748B),
            navBorder: Color(0xFFE2E8F0),
            cardBg: Color(0xFFFFFFFF),
            cardBorder: Color(0xFFCCECEE),
            goldAccent: Color(0xFF0D9488),
            quranVerseText: Color(0xFF134E4A),
            badgeBg: Color(0x1A14B8A6),
            badgeBorder: Color(0x3314B8A6),
            badgeText: Color(0xFF0F766E),
          );
        case PrayerPeriodTheme.sunrise:
          return const AppCustomColors(
            navBarBg: Colors.white,
            navActiveBg: Color(0xFFB45309),
            navActiveContent: Colors.white,
            navInactiveContent: Color(0xFF78716C),
            navBorder: Color(0xFFE7E5E4),
            cardBg: Color(0xFFFFFFFF),
            cardBorder: Color(0xFFFDE68A),
            goldAccent: Color(0xFFD97706),
            quranVerseText: Color(0xFF92400E),
            badgeBg: Color(0x26F59E0B),
            badgeBorder: Color(0x4DF59E0B),
            badgeText: Color(0xFFB45309),
          );
        case PrayerPeriodTheme.dhuhr:
          return light;
        case PrayerPeriodTheme.asr:
          return const AppCustomColors(
            navBarBg: Colors.white,
            navActiveBg: Color(0xFF9A3412),
            navActiveContent: Colors.white,
            navInactiveContent: Color(0xFF78716C),
            navBorder: Color(0xFFE7E5E4),
            cardBg: Color(0xFFFFFFFF),
            cardBorder: Color(0xFFFED7AA),
            goldAccent: Color(0xFFEA580C),
            quranVerseText: Color(0xFF7C2D12),
            badgeBg: Color(0x26EA580C),
            badgeBorder: Color(0x4DEA580C),
            badgeText: Color(0xFFC2410C),
          );
        case PrayerPeriodTheme.maghrib:
          return const AppCustomColors(
            navBarBg: Colors.white,
            navActiveBg: Color(0xFF6B21A8),
            navActiveContent: Colors.white,
            navInactiveContent: Color(0xFF71717A),
            navBorder: Color(0xFFE4E4E7),
            cardBg: Color(0xFFFFFFFF),
            cardBorder: Color(0xFFE9D5FF),
            goldAccent: Color(0xFFC026D3),
            quranVerseText: Color(0xFF581C87),
            badgeBg: Color(0x1AC026D3),
            badgeBorder: Color(0x33C026D3),
            badgeText: Color(0xFF7E22CE),
          );
        case PrayerPeriodTheme.isha:
          return const AppCustomColors(
            navBarBg: Colors.white,
            navActiveBg: Color(0xFF1E3A8A),
            navActiveContent: Colors.white,
            navInactiveContent: Color(0xFF64748B),
            navBorder: Color(0xFFCBD5E1),
            cardBg: Color(0xFFFFFFFF),
            cardBorder: Color(0xFFBFDBFE),
            goldAccent: Color(0xFF2563EB),
            quranVerseText: Color(0xFF1E3A8A),
            badgeBg: Color(0x1A2563EB),
            badgeBorder: Color(0x332563EB),
            badgeText: Color(0xFF1D4ED8),
          );
        case PrayerPeriodTheme.midnight:
          return const AppCustomColors(
            navBarBg: Colors.white,
            navActiveBg: Color(0xFF0F172A),
            navActiveContent: Colors.white,
            navInactiveContent: Color(0xFF64748B),
            navBorder: Color(0xFFCBD5E1),
            cardBg: Color(0xFFFFFFFF),
            cardBorder: Color(0xFFCBD5E1),
            goldAccent: Color(0xFFCA8A04),
            quranVerseText: Color(0xFF0F172A),
            badgeBg: Color(0x1A0F172A),
            badgeBorder: Color(0x330F172A),
            badgeText: Color(0xFF334155),
          );
      }
    }
  }

  @override
  AppCustomColors copyWith({
    Color? navBarBg,
    Color? navActiveBg,
    Color? navActiveContent,
    Color? navInactiveContent,
    Color? navBorder,
    Color? cardBg,
    Color? cardBorder,
    Color? goldAccent,
    Color? quranVerseText,
    Color? badgeBg,
    Color? badgeBorder,
    Color? badgeText,
  }) {
    return AppCustomColors(
      navBarBg: navBarBg ?? this.navBarBg,
      navActiveBg: navActiveBg ?? this.navActiveBg,
      navActiveContent: navActiveContent ?? this.navActiveContent,
      navInactiveContent: navInactiveContent ?? this.navInactiveContent,
      navBorder: navBorder ?? this.navBorder,
      cardBg: cardBg ?? this.cardBg,
      cardBorder: cardBorder ?? this.cardBorder,
      goldAccent: goldAccent ?? this.goldAccent,
      quranVerseText: quranVerseText ?? this.quranVerseText,
      badgeBg: badgeBg ?? this.badgeBg,
      badgeBorder: badgeBorder ?? this.badgeBorder,
      badgeText: badgeText ?? this.badgeText,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      navBarBg: Color.lerp(navBarBg, other.navBarBg, t)!,
      navActiveBg: Color.lerp(navActiveBg, other.navActiveBg, t)!,
      navActiveContent: Color.lerp(navActiveContent, other.navActiveContent, t)!,
      navInactiveContent: Color.lerp(navInactiveContent, other.navInactiveContent, t)!,
      navBorder: Color.lerp(navBorder, other.navBorder, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      goldAccent: Color.lerp(goldAccent, other.goldAccent, t)!,
      quranVerseText: Color.lerp(quranVerseText, other.quranVerseText, t)!,
      badgeBg: Color.lerp(badgeBg, other.badgeBg, t)!,
      badgeBorder: Color.lerp(badgeBorder, other.badgeBorder, t)!,
      badgeText: Color.lerp(badgeText, other.badgeText, t)!,
    );
  }
}

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppCustomColors get customColors =>
      Theme.of(this).extension<AppCustomColors>() ?? AppCustomColors.light;
}
