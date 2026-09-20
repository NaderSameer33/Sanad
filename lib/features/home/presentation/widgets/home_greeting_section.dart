import 'package:flutter/material.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeGreetingSection extends StatelessWidget {
  final String timeSlot;
  final String greeting;
  final String location;
  final String hijriDate;

  const HomeGreetingSection({
    super.key,
    required this.timeSlot,
    required this.greeting,
    required this.location,
    required this.hijriDate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Pill
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.badgeBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.badgeBorder, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      size: 13,
                      color: colors.goldAccent,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      timeSlot,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colors.badgeText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'السلام عليكم ورحمة الله',
                style: AppTextStyles.labelMedium.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Main Greeting Heading
          Text(
            greeting,
            style: AppTextStyles.headlineLarge.copyWith(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 10),

          // Location and Hijri Date metadata
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.cardBorder, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: colors.goldAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 14,
                      color: colors.goldAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hijriDate,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
