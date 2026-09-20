import 'package:flutter/material.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // All colors come dynamically from the active Theme via ThemeExtension
    final colors = context.customColors;

    final navItems = [
      _NavItemData(
        label: 'الرئيسية',
        selectedIcon: Icons.home_rounded,
        unselectedIcon: Icons.home_outlined,
      ),
      _NavItemData(
        label: 'المصحف',
        selectedIcon: Icons.menu_book_rounded,
        unselectedIcon: Icons.menu_book_outlined,
      ),
      _NavItemData(
        label: 'القبلة',
        selectedIcon: Icons.explore_rounded,
        unselectedIcon: Icons.explore_outlined,
      ),
      _NavItemData(
        label: 'الأذكار',
        selectedIcon: Icons.fingerprint_rounded,
        unselectedIcon: Icons.fingerprint_outlined,
      ),
      _NavItemData(
        label: 'القراء',
        selectedIcon: Icons.headset_rounded,
        unselectedIcon: Icons.headphones_outlined,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.navBarBg,
        border: Border(
          top: BorderSide(
            color: colors.navBorder,
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final isSelected = index == currentIndex;
              final item = navItems[index];

              return _NavBarItemWidget(
                item: item,
                isSelected: isSelected,
                colors: colors,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final IconData selectedIcon;
  final IconData unselectedIcon;

  const _NavItemData({
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
  });
}

class _NavBarItemWidget extends StatelessWidget {
  final _NavItemData item;
  final bool isSelected;
  final AppCustomColors colors;
  final VoidCallback onTap;

  const _NavBarItemWidget({
    required this.item,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12 : 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.navActiveBg : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.selectedIcon : item.unselectedIcon,
              size: 22,
              color: isSelected ? colors.navActiveContent : colors.navInactiveContent,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: AppTextStyles.labelSmall.copyWith(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? colors.navActiveContent : colors.navInactiveContent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
