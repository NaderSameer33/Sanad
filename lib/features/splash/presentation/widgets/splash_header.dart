import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashHeader extends StatelessWidget {
  const SplashHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side
          if (isDark)
            _buildBadge(
              context,
              text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              icon: Icons.star_rate_rounded,
              iconColor: AppColors.goldLight,
              textColor: const Color(0xFFC1C8BF),
              bgColor: Colors.white.withValues(alpha: 0.05),
              borderColor: AppColors.darkBorder,
            )
          else
            _buildBadge(
              context,
              text: 'سَنَد',
              icon: Icons.auto_awesome,
              iconColor: AppColors.primary,
              textColor: AppColors.primary,
              bgColor: AppColors.primary.withValues(alpha: 0.08),
              borderColor: AppColors.primary.withValues(alpha: 0.15),
            ),

          // Right side
          if (isDark)
            _buildBadge(
              context,
              text: 'الوضع السَّكِينِي',
              icon: Icons.nights_stay_rounded,
              iconColor: AppColors.sageGreen,
              textColor: const Color(0xFF8C938A),
              bgColor: Colors.white.withValues(alpha: 0.05),
              borderColor: AppColors.darkBorder,
            )
          else
            _buildBadge(
              context,
              text: '١٤٤٦ هـ',
              icon: Icons.calendar_today_rounded,
              iconColor: AppColors.gold,
              textColor: AppColors.lightTextSecondary,
              bgColor: AppColors.lightCard,
              borderColor: AppColors.lightBorder,
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
