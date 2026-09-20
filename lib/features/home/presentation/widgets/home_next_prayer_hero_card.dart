import 'package:flutter/material.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/home_models.dart';

class HomeNextPrayerHeroCard extends StatelessWidget {
  final String nextPrayerName;
  final String remainingTime;
  final List<PrayerTimeItem> prayerTimes;
  final List<PrayerTimeItem> specialTimes;

  const HomeNextPrayerHeroCard({
    super.key,
    required this.nextPrayerName,
    required this.remainingTime,
    required this.prayerTimes,
    this.specialTimes = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final colorScheme = context.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Next prayer info & Countdown chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Next Prayer Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الصلاة القادمة',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.mosque_outlined,
                        size: 20,
                        color: colors.goldAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        nextPrayerName,
                        style: AppTextStyles.headlineMedium.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Glowing Countdown Chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.badgeBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colors.goldAccent.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الوقت المتبقي للأذان',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 10,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 13,
                          color: colors.goldAccent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'متبقي $remainingTime',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.goldAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 5 Prayers Horizontal Timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: prayerTimes.map((item) {
              return _buildPrayerItem(context, item, colors, colorScheme);
            }).toList(),
          ),

          if (specialTimes.isNotEmpty) ...[
            const SizedBox(height: 14),
            // Special Night & Sun Times Section (الشروق • منتصف الليل • الثلث الأخير)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: colors.badgeBg.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colors.cardBorder.withValues(alpha: 0.6),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  for (int i = 0; i < specialTimes.length; i++) ...[
                    if (i > 0)
                      Container(
                        height: 28,
                        width: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        color: colors.cardBorder.withValues(alpha: 0.7),
                      ),
                    Expanded(
                      child: _buildSpecialItem(
                        context,
                        specialTimes[i],
                        colors,
                        colorScheme,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrayerItem(
    BuildContext context,
    PrayerTimeItem item,
    AppCustomColors colors,
    ColorScheme colorScheme,
  ) {
    final isNext = item.isNext;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isNext ? colors.navActiveBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(color: colors.goldAccent.withValues(alpha: 0.7), width: 1.2)
            : Border.all(color: colors.cardBorder.withValues(alpha: 0.5), width: 0.8),
      ),
      child: Column(
        children: [
          if (isNext)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: colors.goldAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'القادمة',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          Text(
            item.name,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
              color: isNext
                  ? colors.navActiveContent
                  : colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.time,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
              color: isNext ? colors.navActiveContent : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialItem(
    BuildContext context,
    PrayerTimeItem item,
    AppCustomColors colors,
    ColorScheme colorScheme,
  ) {
    IconData icon;
    String subtitle;
    if (item.name.contains('الشروق')) {
      icon = Icons.wb_sunny_outlined;
      subtitle = 'شروق الشمس';
    } else if (item.name.contains('منتصف الليل')) {
      icon = Icons.nightlight_round;
      subtitle = 'نهاية العشاء';
    } else {
      icon = Icons.auto_awesome_outlined;
      subtitle = 'قيام الليل';
    }

    final isNext = item.isNext;

    return Tooltip(
      message: '$subtitle: ${item.name} (${item.time})',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: isNext ? colors.badgeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isNext ? colors.goldAccent : colorScheme.primary,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                      color: isNext
                          ? colors.goldAccent
                          : colorScheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                  Text(
                    item.time,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
