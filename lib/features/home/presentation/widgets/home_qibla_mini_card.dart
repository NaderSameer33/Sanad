import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeQiblaMiniCard extends StatelessWidget {
  final double qiblaAngle;

  const HomeQiblaMiniCard({
    super.key,
    this.qiblaAngle = 245.0,
  });

  String _toArabic(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String res = number.toString();
    for (int i = 0; i < english.length; i++) {
      res = res.replaceAll(english[i], arabic[i]);
    }
    return res;
  }

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
                    Icons.explore_rounded,
                    size: 18,
                    color: colors.goldAccent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'اتجاه القبلة',
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
                  '${_toArabic(qiblaAngle.toInt())}° ش.غ',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.goldAccent,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Kaaba Heading Description
          Text(
            'الكعبة المشرفة',
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'الهاتف موجه بدقة نحو المسجد الحرام بمكة المكرمة',
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          // Open Full Compass Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.go(Routes.qibla);
              },
              icon: const Icon(Icons.navigation_rounded, size: 16),
              label: const Text('فتح البوصلة الكاملة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.navActiveBg,
                foregroundColor: colors.navActiveContent,
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
