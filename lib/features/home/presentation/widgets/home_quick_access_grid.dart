import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeQuickAccessGrid extends StatelessWidget {
  const HomeQuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final colorScheme = context.colorScheme;

    final cards = [
      _QuickAccessItem(
        title: 'ختمة القرآن',
        subtitle: 'الجزء ١٨ • صفحة ٣٥٠',
        icon: Icons.menu_book_rounded,
        route: Routes.quran,
      ),
      _QuickAccessItem(
        title: 'حصن المسلم',
        subtitle: 'أدعية مأثورة',
        icon: Icons.security_rounded,
        route: Routes.athkar,
      ),
      _QuickAccessItem(
        title: 'تلاوات خاشعة',
        subtitle: 'كبار القراء',
        icon: Icons.headset_rounded,
        route: Routes.reciters,
      ),
      _QuickAccessItem(
        title: 'المسبحة',
        subtitle: '١٤٢ استغفار',
        icon: Icons.fingerprint_rounded,
        route: Routes.athkar,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الوصول السريع',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (context, index) {
              final item = cards[index];

              return InkWell(
                onTap: () {
                  context.go(item.route);
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.cardBorder, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colors.badgeBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          size: 18,
                          color: colors.goldAccent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickAccessItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const _QuickAccessItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}
