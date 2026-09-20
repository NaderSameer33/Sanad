import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/services/di.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/logic/theme_cubit.dart';

class HomeTopBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        'سَـنَـد',
        style: AppTextStyles.displayMedium.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.settings_outlined),
        tooltip: 'الإعدادات',
        onPressed: () {
          context.push(Routes.settings);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.brightness_medium_rounded),
          tooltip: 'تبديل المظهر',
          onPressed: () {
            getIt<ThemeCubit>().toggleTheme();
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
          tooltip: 'التنبيهات',
          onPressed: () {
            context.push(Routes.notifications);
          },
        ),
      ],
    );
  }
}
