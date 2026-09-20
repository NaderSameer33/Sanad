import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/di.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/quran_models.dart';
import '../../data/repos/quran_repository.dart';
import '../../logic/quran_cubit.dart';
import '../../logic/quran_state.dart';
import 'surah_detail_view.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuranCubit(getIt<QuranRepository>()),
      child: const _QuranViewContent(),
    );
  }
}

class _QuranViewContent extends StatelessWidget {
  const _QuranViewContent();

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
    final cubit = context.read<QuranCubit>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'المصحف الشريف',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.goldAccent),
            );
          }

          return Column(
            children: [
              // Search Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  onChanged: (q) => cubit.filterSurahs(q),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن سورة أو رقمها...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(Icons.search_rounded, color: colors.goldAccent),
                    filled: true,
                    fillColor: colors.cardBg,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.goldAccent, width: 1.5),
                    ),
                  ),
                ),
              ),

              // Last Read Card (if exists)
              if (state.lastRead != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: colors.navActiveBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.goldAccent.withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bookmark_rounded, color: colors.goldAccent, size: 22),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تابع القراءة',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                                Text(
                                  'سورة رقم ${_toArabic(state.lastRead!['surahNumber'])} • صفحة ${_toArabic(state.lastRead!['pageNumber'])}',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.navActiveContent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colors.goldAccent),
                      ],
                    ),
                  ),
                ),

              // Segmented Tab Switcher (السور / الأجزاء)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                              'السور (${_toArabic(state.surahs.length)})',
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
                              'الأجزاء (٣٠)',
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

              // List Content
              Expanded(
                child: state.selectedTab == 0
                    ? _buildSurahsList(context, state.filteredSurahs, colors, colorScheme)
                    : _buildJuzList(context, state.juzList, colors, colorScheme),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSurahsList(
    BuildContext context,
    List<Surah> surahs,
    AppCustomColors colors,
    ColorScheme colorScheme,
  ) {
    if (surahs.isEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج بحث',
          style: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: surahs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final surah = surahs[index];

        return InkWell(
          onTap: () {
            context.read<QuranCubit>().saveLastRead(
                  surahNumber: surah.number,
                  verseNumber: 1,
                  pageNumber: surah.verses.isNotEmpty ? surah.verses.first.page : 1,
                );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SurahDetailView(surah: surah),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.cardBorder, width: 0.8),
            ),
            child: Row(
              children: [
                // Surah Number
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.badgeBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.badgeBorder, width: 1.0),
                  ),
                  child: Center(
                    child: Text(
                      _toArabic(surah.number),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: colors.goldAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Surah Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.nameAr,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${surah.revelationPlace} • ${_toArabic(surah.versesCount)} آية',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Transliteration & Page
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      surah.transliteration,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'صفحة ${_toArabic(surah.verses.isNotEmpty ? surah.verses.first.page : 1)}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colors.goldAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildJuzList(
    BuildContext context,
    List<JuzItem> juzList,
    AppCustomColors colors,
    ColorScheme colorScheme,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: juzList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = juzList[index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.cardBorder, width: 0.8),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.badgeBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.badgeBorder, width: 1.0),
                ),
                child: Center(
                  child: Text(
                    _toArabic(item.juzNumber),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: colors.goldAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الجزء ${_toArabic(item.juzNumber)}',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'بداية من سورة ${item.startSurahName} (الآية ${_toArabic(item.startVerseNumber)})',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'صفحة ${_toArabic(item.pageNumber)}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.goldAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
