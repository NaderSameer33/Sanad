import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/home_models.dart';

class HomeVerseOfDayCard extends StatelessWidget {
  final VerseOfDay verse;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const HomeVerseOfDayCard({
    super.key,
    required this.verse,
    required this.isExpanded,
    required this.onToggleExpand,
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.cardBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Chip & Surah Source
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.badgeBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.badgeBorder, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 13,
                      color: colors.goldAccent,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'آية وتأمل اليوم',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colors.badgeText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${verse.surahName} • الآية ${verse.ayahNumber}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quranic Script Verse Text
          Center(
            child: Column(
              children: [
                Text(
                  verse.arabicText,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.quranVerse.copyWith(
                    fontSize: 24,
                    color: colors.quranVerseText,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'صدق الله العظيم',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          Divider(color: colors.cardBorder, height: 1),
          const SizedBox(height: 12),

          // Tafsir Excerpt
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                verse.tafsirSource,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.goldAccent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                verse.tafsirText,
                maxLines: isExpanded ? 10 : 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  height: 1.6,
                  color: colorScheme.onSurface.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Action Buttons: Read Full Tafsir, Copy, Share
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onToggleExpand,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: BorderSide(color: colors.cardBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: colors.goldAccent,
                  ),
                  label: Text(
                    isExpanded ? 'إخفاء التفسير' : 'قراءة التفسير كاملاً',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                    text: '${verse.arabicText}\n${verse.surahName} [${verse.ayahNumber}]',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم نسخ الآية الكريمة'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 16),
                style: IconButton.styleFrom(
                  side: BorderSide(color: colors.cardBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                tooltip: 'نسخ الآية',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
