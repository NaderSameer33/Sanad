import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashCenterEmblem extends StatelessWidget {
  const SplashCenterEmblem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Subtitle with decorative divider
        if (isDark)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 1,
                color: AppColors.goldLight.withValues(alpha: 0.4),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'نُورٌ وَطُمَأْنِينَة',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.goldLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 1,
                color: AppColors.goldLight.withValues(alpha: 0.4),
              ),
            ],
          ),

        const SizedBox(height: 8),

        // App Title "سَـنَـد"
        Text(
          'سَـنَـد',
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDark ? const Color(0xFFDAE5DB) : AppColors.primary,
          ),
        ),

        const SizedBox(height: 4),

        // Sub-headline Tagline
        Text(
          'رَفِيقُ المُسْلِمِ القُرْآنِي',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.goldLight : AppColors.gold,
          ),
        ),

        const SizedBox(height: 8),

        // Spiritual reflection phrase
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            isDark
                ? 'رَفِيقُكَ فِي رِحْلَةِ القُرْآنِ، الأَذْكَارِ، وَالطَّمَأْنِينَةِ اليَوْمِيَّة'
                : 'تلاوة، أذكار، ومواقيت الصلاة في بيئة روحانية هادئة خالية من التشتت',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? const Color(0xFFC1C8BF)
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Central Logo Emblem with glowing outer architecture
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? const Color(0xFF07100B) : Colors.white,
            border: Border.all(
              color: isDark
                  ? AppColors.primaryLight
                  : AppColors.gold.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppColors.primaryLight.withValues(alpha: 0.3)
                    : AppColors.gold.withValues(alpha: 0.2),
                blurRadius: 28,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/images/app_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.menu_book_rounded,
                size: 54,
                color: isDark ? AppColors.goldLight : AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
