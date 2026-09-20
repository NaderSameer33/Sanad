import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/home_models.dart';

class HomeWirdProgressCard extends StatelessWidget {
  final WirdProgress wird;

  const HomeWirdProgressCard({
    super.key,
    required this.wird,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.cardBorder, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.fingerprint_rounded,
                    size: 18,
                    color: colors.goldAccent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'ورد اليوم',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.badgeBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.badgeBorder, width: 0.8),
                ),
                child: Text(
                  'مكتمل ${wird.percent}%',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.goldAccent,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Wird Category & Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                wird.title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${wird.completedCount} من ${wird.totalCount} ذِكر',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: wird.progress,
                backgroundColor: colorScheme.onSurface.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(colors.goldAccent),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Next Dhikr Teaser
          Text(
            'الذكر القادم: ${wird.nextDhikr}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 12),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.go(Routes.athkar);
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('متابعة الأذكار'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.cardBorder),
                foregroundColor: colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
