import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/services/di.dart';
import '../../../../core/services/hijri_date_service.dart';
import '../../../../core/services/prayer_time_service.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/logic/theme_cubit.dart';
import '../../../../core/theme/logic/theme_state.dart';
import '../../data/repos/settings_repository.dart';
import '../../logic/settings_cubit.dart';
import '../../logic/settings_state.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(
        repository: getIt<SettingsRepository>(),
        hijriDateService: getIt<HijriDateService>(),
      ),
      child: const _SettingsViewBody(),
    );
  }
}

class _SettingsViewBody extends StatelessWidget {
  const _SettingsViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'الإعدادات',
          style: AppTextStyles.headlineMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          final settings = state.settings;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Section 1: Appearance
              _buildSectionHeader(context, 'المظهر والسمات', Icons.palette_outlined),
              const SizedBox(height: 12),
              _buildCardContainer(
                context,
                children: [
                  ListTile(
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        theme.brightness == Brightness.dark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'المظهر الأساسي',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      theme.brightness == Brightness.dark ? 'الوضع الداكن (الليلي)' : 'الوضع الفاتح (النهاري)',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    trailing: OutlinedButton(
                      onPressed: () {
                        getIt<ThemeCubit>().toggleTheme();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'تبديل',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  BlocBuilder<ThemeCubit, ThemeState>(
                    bloc: getIt<ThemeCubit>(),
                    builder: (context, themeState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            secondary: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                color: theme.colorScheme.secondary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              'مظهر مواقيت الصلاة التلقائي (Dynamic Theme)',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'يتكيف لون التطبيق تلقائياً مع وقت الصلاة الحالي (فجر، شروق، ظهر، عصر، مغرب، عشاء، قيام ليل)',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            value: themeState.isDynamicThemeEnabled,
                            activeThumbColor: theme.colorScheme.primary,
                            onChanged: (val) {
                              getIt<ThemeCubit>().toggleDynamicTheme(val);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              'تجربة مظهر الصلوات:',
                              style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Row(
                              children: [
                                _buildPrayerThemeChip(
                                  context: context,
                                  period: PrayerPeriodTheme.fajr,
                                  label: 'الفجر 🌅',
                                  color: const Color(0xFF14B8A6),
                                  activePeriod: themeState.activePrayerTheme,
                                ),
                                const SizedBox(width: 8),
                                _buildPrayerThemeChip(
                                  context: context,
                                  period: PrayerPeriodTheme.sunrise,
                                  label: 'الشروق ☀️',
                                  color: const Color(0xFFF59E0B),
                                  activePeriod: themeState.activePrayerTheme,
                                ),
                                const SizedBox(width: 8),
                                _buildPrayerThemeChip(
                                  context: context,
                                  period: PrayerPeriodTheme.dhuhr,
                                  label: 'الظهر 🕌',
                                  color: const Color(0xFF22C55E),
                                  activePeriod: themeState.activePrayerTheme,
                                ),
                                const SizedBox(width: 8),
                                _buildPrayerThemeChip(
                                  context: context,
                                  period: PrayerPeriodTheme.asr,
                                  label: 'العصر 🌇',
                                  color: const Color(0xFFEA580C),
                                  activePeriod: themeState.activePrayerTheme,
                                ),
                                const SizedBox(width: 8),
                                _buildPrayerThemeChip(
                                  context: context,
                                  period: PrayerPeriodTheme.maghrib,
                                  label: 'المغرب 🌆',
                                  color: const Color(0xFFC026D3),
                                  activePeriod: themeState.activePrayerTheme,
                                ),
                                const SizedBox(width: 8),
                                _buildPrayerThemeChip(
                                  context: context,
                                  period: PrayerPeriodTheme.isha,
                                  label: 'العشاء 🌙',
                                  color: const Color(0xFF3B82F6),
                                  activePeriod: themeState.activePrayerTheme,
                                ),
                                const SizedBox(width: 8),
                                _buildPrayerThemeChip(
                                  context: context,
                                  period: PrayerPeriodTheme.midnight,
                                  label: 'قيام الليل 🌌',
                                  color: const Color(0xFFFCD34D),
                                  activePeriod: themeState.activePrayerTheme,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Section 2: Hijri Calendar Adjustment
              _buildSectionHeader(context, 'التقويم الهجري', Icons.calendar_month_rounded),
              const SizedBox(height: 12),
              _buildCardContainer(
                context,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Live Result Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.event_available_rounded, color: colors.goldAccent, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  state.formattedHijriPreview.isNotEmpty
                                      ? state.formattedHijriPreview
                                      : 'جاري الحساب...',
                                  style: AppTextStyles.titleSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'تعديل التاريخ لمطابقة الرؤية الشرعية:',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Adjustment selector chips (-2, -1, 0, +1, +2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [-2, -1, 0, 1, 2].map((val) {
                            final isSelected = settings.hijriAdjustment == val;
                            final label = val == 0
                                ? 'تلقائي'
                                : (val > 0 ? '+$val يوم' : '$val يوم');

                            return InkWell(
                              onTap: () => cubit.updateHijriAdjustment(val),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : colors.cardBg,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : colors.cardBorder,
                                  ),
                                ),
                                child: Text(
                                  label,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : theme.colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Section 3: Quran Font Size
              _buildSectionHeader(context, 'المصحف الشريف', Icons.menu_book_rounded),
              const SizedBox(height: 12),
              _buildCardContainer(
                context,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'حجم خط الآيات',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${settings.quranFontSize.toInt()} pt',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colors.goldAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: settings.quranFontSize,
                          min: 18.0,
                          max: 34.0,
                          divisions: 8,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (newVal) => cubit.updateQuranFontSize(newVal),
                        ),
                        // Live Ayah Preview
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: colors.badgeBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ ﴿١﴾',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiri(
                              fontSize: settings.quranFontSize,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Section 4: Prayer Times & Notifications
              _buildSectionHeader(context, 'المواقيت والتنبيهات', Icons.notifications_active_outlined),
              const SizedBox(height: 12),
              _buildCardContainer(
                context,
                children: [
                  ListTile(
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.tune_rounded, color: theme.colorScheme.primary, size: 20),
                    ),
                    title: Text(
                      'ضبط أصوات الأذان والإشعارات',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'التحكم في مواقيت الصلوات الخمس والأذكار وسورة الكهف',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colors.goldAccent),
                    onTap: () => context.push(Routes.notifications),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Section 5: About App
              _buildSectionHeader(context, 'عن التطبيق', Icons.info_outline_rounded),
              const SizedBox(height: 12),
              _buildCardContainer(
                context,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: colors.badgeBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: colors.goldAccent.withValues(alpha: 0.3)),
                              ),
                              child: Center(
                                child: Text(
                                  'سَنَد',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.goldAccent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'سَنَد - رفيقك اليومي للطاعة والذكر',
                                    style: AppTextStyles.titleSmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'الإصدار 1.0.0 (تطبيق أوفلاين كامل)',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'تطبيق إسلامي مجاني لوجه الله تعالى، مصمم ليجمع لك المصحف الشريف، مواقيت الصلاة الفلكية، الأذكار اليومية، القبلة، والتلاوات بأعلى جودة وإتقان.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer(BuildContext context, {required List<Widget> children}) {
    final colors = context.customColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildPrayerThemeChip({
    required BuildContext context,
    required PrayerPeriodTheme period,
    required String label,
    required Color color,
    required PrayerPeriodTheme activePeriod,
  }) {
    final isSelected = activePeriod == period;
    return GestureDetector(
      onTap: () {
        getIt<ThemeCubit>().setPrayerPeriodTheme(period);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
