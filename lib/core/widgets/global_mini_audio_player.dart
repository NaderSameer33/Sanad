import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/di.dart';
import '../theme/app_custom_colors.dart';
import '../theme/app_text_styles.dart';

class GlobalMiniAudioPlayer extends StatelessWidget {
  const GlobalMiniAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = getIt<AudioService>();
    final colors = context.customColors;
    final colorScheme = context.colorScheme;

    return StreamBuilder<AudioPlaybackInfo>(
      stream: audioService.playbackStream,
      initialData: audioService.currentInfo,
      builder: (context, snapshot) {
        final info = snapshot.data;
        if (info == null || !info.hasActiveAudio) {
          return const SizedBox.shrink();
        }

        final progress = info.duration.inMilliseconds > 0
            ? (info.position.inMilliseconds / info.duration.inMilliseconds).clamp(0.0, 1.0)
            : 0.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.goldAccent.withValues(alpha: 0.35), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Thin Progress Bar
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: colors.cardBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.goldAccent),
                  minHeight: 2.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Audio Icon or Equalizer Icon
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.goldAccent.withValues(alpha: 0.15),
                        ),
                        child: Icon(
                          info.isPlaying ? Icons.graphic_eq_rounded : Icons.music_note_rounded,
                          color: colors.goldAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title and Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              info.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              info.subTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Play/Pause Button
                      IconButton(
                        onPressed: () => audioService.togglePlayPause(),
                        icon: Icon(
                          info.isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: colors.goldAccent,
                          size: 32,
                        ),
                        tooltip: info.isPlaying ? 'إيقاف مؤقت' : 'متابعة التشغيل',
                      ),

                      // Close (Stop) Button
                      IconButton(
                        onPressed: () => audioService.stop(),
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.onSurface.withValues(alpha: 0.08),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        tooltip: 'إغلاق المشغل',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
