import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashLoadingFooter extends StatelessWidget {
  final double progress;
  final String statusMessage;

  const SplashLoadingFooter({
    super.key,
    required this.progress,
    required this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentInt = (progress * 100).clamp(0, 100).toInt();
    final arabicPercent = _toArabicDigits(percentInt.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusMessage,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isDark ? AppColors.sageGreen : AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                '$arabicPercent٪',
                style: AppTextStyles.labelSmall.copyWith(
                  color: isDark ? AppColors.goldLight : AppColors.goldDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 5,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark
                    ? const Color(0xFF222C26)
                    : const Color(0xFFE9E8E3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.goldLight : AppColors.gold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isDark) ...[
                const Icon(
                  Icons.favorite_rounded,
                  size: 11,
                  color: AppColors.sageGreen,
                ),
                const SizedBox(width: 6),
                Text(
                  'صُمِّمَ بِإِحْسَان',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: const Color(0xFFC1C8BF),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: const Color(0xFF667365),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'الإِصْدَار ١.٠.٠',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: const Color(0xFFC1C8BF),
                    fontSize: 11,
                  ),
                ),
              ] else ...[
                Text(
                  'الإصدار ١.٠.٠',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.verified_outlined,
                  size: 12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'مراجعة مجمع الملك فهد',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
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
    return input.split('').map((char) => englishToArabic[char] ?? char).join('');
  }
}
