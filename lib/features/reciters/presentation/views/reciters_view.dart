import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/di.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/repos/reciters_repository.dart';
import '../../logic/reciters_cubit.dart';
import '../../logic/reciters_state.dart';
import 'reciter_detail_view.dart';

class RecitersView extends StatelessWidget {
  const RecitersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecitersCubit(
        getIt<RecitersRepository>(),
        getIt<AudioService>(),
      ),
      child: const _RecitersViewContent(),
    );
  }
}

class _RecitersViewContent extends StatelessWidget {
  const _RecitersViewContent();

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
    final cubit = context.read<RecitersCubit>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'القراء والتلاوات',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<RecitersCubit, RecitersState>(
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
                  onChanged: (q) => cubit.search(q),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن قارئ...',
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

              // Reciters Count Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'كبار القراء والمقرئين',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${_toArabic(state.filteredReciters.length)} قارئ',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colors.goldAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Reciters List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  itemCount: state.filteredReciters.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final reciter = state.filteredReciters[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReciterDetailView(reciter: reciter),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: colors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.cardBorder, width: 0.9),
                        ),
                        child: Row(
                          children: [
                            // Avatar Letter
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: colors.badgeBg,
                                shape: BoxShape.circle,
                                border: Border.all(color: colors.badgeBorder, width: 1.0),
                              ),
                              child: Center(
                                child: Text(
                                  reciter.letter.isNotEmpty ? reciter.letter : 'ق',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.goldAccent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Reciter Name and Moshafs
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reciter.name,
                                    style: AppTextStyles.labelLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    reciter.moshafList.map((m) => m.name).join(' • '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),

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
                ),
              ),

              // Persistent Mini Player if active
              if (state.playbackInfo.hasActiveAudio)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.navActiveBg,
                    border: Border(top: BorderSide(color: colors.goldAccent, width: 1.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.graphic_eq_rounded, color: colors.goldAccent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.playbackInfo.title,
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.navActiveContent,
                              ),
                            ),
                            Text(
                              state.playbackInfo.subTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colors.navActiveContent.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => cubit.togglePlayPause(),
                        icon: Icon(
                          state.playbackInfo.isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: colors.goldAccent,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: () => cubit.stopAudio(),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: colors.navActiveContent.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
