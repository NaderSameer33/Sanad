import 'package:flutter/material.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/di.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/reciter_models.dart';

class ReciterDetailView extends StatefulWidget {
  final Reciter reciter;

  const ReciterDetailView({
    super.key,
    required this.reciter,
  });

  @override
  State<ReciterDetailView> createState() => _ReciterDetailViewState();
}

class _ReciterDetailViewState extends State<ReciterDetailView> {
  final AudioService _audioService = getIt<AudioService>();
  late MoshafInfo _selectedMoshaf;
  AudioPlaybackInfo _playbackInfo = const AudioPlaybackInfo();

  static const List<String> surahNames = [
    'الفاتحة', 'البقرة', 'آل عمران', 'النساء', 'المائدة', 'الأنعام', 'الأعراف', 'الأنفال', 'التوبة', 'يونس',
    'هود', 'يوسف', 'الرعد', 'إبراهيم', 'الحجر', 'النحل', 'الإسراء', 'الكهف', 'مريم', 'طه',
    'الأنبياء', 'الحج', 'المؤمنون', 'النور', 'الفرقان', 'الشعراء', 'النمل', 'القصص', 'العنكبوت', 'الروم',
    'لقمان', 'السجدة', 'الأحزاب', 'سبأ', 'فاطر', 'يس', 'الصافات', 'ص', 'الزمر', 'غافر',
    'فصلت', 'الشورى', 'الزخرف', 'الدخان', 'الجاثية', 'الأحقاف', 'محمد', 'الفتح', 'الحجرات', 'ق',
    'الذاريات', 'الطور', 'النجم', 'القمر', 'الرحمن', 'الواقعة', 'الحديد', 'المجادلة', 'الحشر', 'الممتحنة',
    'الصف', 'الجمعة', 'المنافقون', 'التغابن', 'الطلاق', 'التحريم', 'الملك', 'القلم', 'الحاقة', 'المعارج',
    'نوح', 'الجن', 'المزمل', 'المدثر', 'القيامة', 'الإنسان', 'المرسلات', 'النبأ', 'النازعات', 'عبس',
    'التكوير', 'الانفطار', 'المطففين', 'الانشقاق', 'البروج', 'الطارق', 'الأعلى', 'الغاشية', 'الفجر', 'البلد',
    'الشمس', 'الليل', 'الضحى', 'الشرح', 'التين', 'العلق', 'القدر', 'البينة', 'الزلزلة', 'العاديات',
    'القارعة', 'التكاثر', 'العصر', 'الهمزة', 'الفيل', 'قريش', 'الماعون', 'الكوثر', 'الكافرون', 'النصر',
    'المسد', 'الإخلاص', 'الفلق', 'الناس'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMoshaf = widget.reciter.moshafList.first;
    _playbackInfo = _audioService.currentInfo;

    _audioService.playbackStream.listen((info) {
      if (mounted) {
        setState(() {
          _playbackInfo = info;
        });
      }
    });
  }

  void _playSurah(int surahNum) {
    final surahName = surahNum <= surahNames.length ? surahNames[surahNum - 1] : 'سورة $surahNum';
    final url = _selectedMoshaf.getSurahAudioUrl(surahNum);

    _audioService.playAudio(
      url: url,
      title: 'سورة $surahName',
      subTitle: '${widget.reciter.name} (${_selectedMoshaf.name})',
    );
  }

  String _toArabic(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String res = number.toString();
    for (int i = 0; i < english.length; i++) {
      res = res.replaceAll(english[i], arabic[i]);
    }
    return res;
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final colorScheme = context.colorScheme;
    final reciter = widget.reciter;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          reciter.name,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header Card with Moshaf selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.badgeBg,
                    child: Text(
                      reciter.letter.isNotEmpty ? reciter.letter : 'ق',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colors.goldAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reciter.name,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (reciter.moshafList.length > 1) ...[
                    const SizedBox(height: 12),
                    DropdownButton<MoshafInfo>(
                      value: _selectedMoshaf,
                      isExpanded: true,
                      dropdownColor: colors.cardBg,
                      underline: const SizedBox(),
                      items: reciter.moshafList.map((m) {
                        return DropdownMenuItem(
                          value: m,
                          child: Text(
                            m.name,
                            style: AppTextStyles.bodyMedium.copyWith(color: colors.goldAccent),
                          ),
                        );
                      }).toList(),
                      onChanged: (newMoshaf) {
                        if (newMoshaf != null) {
                          setState(() {
                            _selectedMoshaf = newMoshaf;
                          });
                        }
                      },
                    ),
                  ] else ...[
                    const SizedBox(height: 4),
                    Text(
                      _selectedMoshaf.name,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colors.goldAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Surahs List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _selectedMoshaf.availableSurahs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final surahNum = _selectedMoshaf.availableSurahs[index];
                final surahName = surahNum <= surahNames.length ? surahNames[surahNum - 1] : 'سورة $surahNum';
                final isCurrentAudio = _playbackInfo.title == 'سورة $surahName';
                final isPlayingThis = isCurrentAudio && _playbackInfo.isPlaying;

                return InkWell(
                  onTap: () {
                    if (isCurrentAudio) {
                      _audioService.togglePlayPause();
                    } else {
                      _playSurah(surahNum);
                    }
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: isCurrentAudio ? colors.navActiveBg : colors.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCurrentAudio ? colors.goldAccent : colors.cardBorder,
                        width: isCurrentAudio ? 1.2 : 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.badgeBg,
                            border: Border.all(color: colors.badgeBorder),
                          ),
                          child: Center(
                            child: Text(
                              _toArabic(surahNum),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colors.goldAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'سورة $surahName',
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCurrentAudio ? colors.navActiveContent : colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          isPlayingThis
                              ? Icons.pause_circle_filled_rounded
                              : (isCurrentAudio ? Icons.play_circle_fill_rounded : Icons.play_arrow_rounded),
                          color: colors.goldAccent,
                          size: 26,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Audio Player Bottom Sheet if playing
          if (_playbackInfo.hasActiveAudio)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.cardBg,
                border: Border(top: BorderSide(color: colors.cardBorder, width: 1.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.audiotrack_rounded, color: colors.goldAccent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _playbackInfo.title,
                              style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _playbackInfo.subTitle,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _audioService.togglePlayPause(),
                        icon: Icon(
                          _playbackInfo.isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: colors.goldAccent,
                          size: 32,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _audioService.stop(),
                        icon: Icon(Icons.close_rounded, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                  if (_playbackInfo.duration > Duration.zero) ...[
                    Slider(
                      value: _playbackInfo.position.inSeconds.toDouble().clamp(
                            0.0,
                            _playbackInfo.duration.inSeconds.toDouble(),
                          ),
                      max: _playbackInfo.duration.inSeconds.toDouble(),
                      activeColor: colors.goldAccent,
                      inactiveColor: colors.cardBorder,
                      onChanged: (val) {
                        _audioService.seek(Duration(seconds: val.toInt()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_playbackInfo.position),
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 10,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            _formatDuration(_playbackInfo.duration),
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 10,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
