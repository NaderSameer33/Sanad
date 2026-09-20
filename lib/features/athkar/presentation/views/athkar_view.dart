import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/di.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/repos/athkar_repository.dart';
import '../../logic/athkar_cubit.dart';
import '../../logic/athkar_state.dart';
import '../widgets/animated_smart_tasbeeh_widget.dart';
import 'athkar_category_detail_view.dart';

class AthkarView extends StatelessWidget {
  const AthkarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AthkarCubit(getIt<AthkarRepository>()),
      child: const _AthkarViewContent(),
    );
  }
}

class _AthkarViewContent extends StatelessWidget {
  const _AthkarViewContent();

  String _toArabic(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String res = number.toString();
    for (int i = 0; i < english.length; i++) {
      res = res.replaceAll(english[i], arabic[i]);
    }
    return res;
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains('صباح')) return Icons.wb_sunny_rounded;
    if (category.contains('مساء')) return Icons.nights_stay_rounded;
    if (category.contains('صلاة')) return Icons.mosque_rounded;
    if (category.contains('نوم')) return Icons.bedtime_rounded;
    if (category.contains('استيقاظ')) return Icons.wb_twilight_rounded;
    if (category.contains('تسابيح')) return Icons.fingerprint_rounded;
    if (category.contains('قرآن')) return Icons.menu_book_rounded;
    return Icons.auto_stories_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final colorScheme = context.colorScheme;
    final cubit = context.read<AthkarCubit>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الأذكار والمسبحة',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<AthkarCubit, AthkarState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.goldAccent),
            );
          }

          return Column(
            children: [
              // Segmented Tab Switcher
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => cubit.switchTab(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: state.selectedTab == 0 ? colors.navActiveBg : colors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: state.selectedTab == 0 ? colors.goldAccent : colors.cardBorder,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'أقسام الأذكار (${_toArabic(state.categories.length)})',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: state.selectedTab == 0
                                    ? colors.navActiveContent
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => cubit.switchTab(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: state.selectedTab == 1 ? colors.navActiveBg : colors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: state.selectedTab == 1 ? colors.goldAccent : colors.cardBorder,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'المسبحة الإلكترونية',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: state.selectedTab == 1
                                    ? colors.navActiveContent
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // View Body
              Expanded(
                child: state.selectedTab == 0
                    ? _buildCategoriesList(context, state, colors, colorScheme)
                    : _buildTasbeehTab(context, state, cubit, colors, colorScheme),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    AthkarState state,
    AppCustomColors colors,
    ColorScheme colorScheme,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: state.categories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final categoryName = state.categories[index];
        final items = state.allAthkar[categoryName] ?? [];
        final icon = _getCategoryIcon(categoryName);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AthkarCategoryDetailView(
                  categoryTitle: categoryName,
                  items: items,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.cardBorder, width: 0.9),
            ),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.badgeBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.badgeBorder, width: 0.8),
                  ),
                  child: Icon(icon, color: colors.goldAccent, size: 22),
                ),
                const SizedBox(width: 14),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_toArabic(items.length)} ذكراً ودعاءً',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: colors.goldAccent,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTasbeehTab(
    BuildContext context,
    AthkarState state,
    AthkarCubit cubit,
    AppCustomColors colors,
    ColorScheme colorScheme,
  ) {
    return AnimatedSmartTasbeehWidget(state: state, cubit: cubit);
  }
}
