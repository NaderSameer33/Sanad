import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/di.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/quran_models.dart';
import '../../data/repos/quran_repository.dart';

class SurahDetailView extends StatefulWidget {
  final Surah surah;

  const SurahDetailView({
    super.key,
    required this.surah,
  });

  @override
  State<SurahDetailView> createState() => _SurahDetailViewState();
}

class _SurahDetailViewState extends State<SurahDetailView> {
  final AudioService _audioService = getIt<AudioService>();
  final QuranRepository _quranRepository = getIt<QuranRepository>();
  bool _isPlaying = false;
  double _fontSize = 22.0;
  bool _isVerseByVerse = false;

  @override
  void initState() {
    super.initState();
    final savedFontSize = CacheHelper.getData(key: 'quran_font_size');
    if (savedFontSize is double) {
      _fontSize = savedFontSize;
    } else if (savedFontSize is int) {
      _fontSize = savedFontSize.toDouble();
    }

    _audioService.playbackStream.listen((info) {
      if (mounted) {
        setState(() {
          _isPlaying = info.isPlaying && info.title == 'سورة ${widget.surah.nameAr}';
        });
      }
    });

    // Save as last read
    _quranRepository.saveLastRead(
      surahNumber: widget.surah.number,
      verseNumber: 1,
      pageNumber: widget.surah.verses.isNotEmpty ? widget.surah.verses.first.page : 1,
    );
  }

  void _toggleAudio() {
    final formattedNumber = widget.surah.number.toString().padLeft(3, '0');
    final url = 'https://server8.mp3quran.net/afs/$formattedNumber.mp3';

    if (_isPlaying) {
      _audioService.togglePlayPause();
    } else {
      _audioService.playAudio(
        url: url,
        title: 'سورة ${widget.surah.nameAr}',
        subTitle: 'مشاري العفاسي',
      );
    }
  }

  void _increaseFontSize() {
    if (_fontSize < 34) {
      setState(() {
        _fontSize += 2;
      });
      CacheHelper.saveData(key: 'quran_font_size', value: _fontSize);
    }
  }

  void _decreaseFontSize() {
    if (_fontSize > 16) {
      setState(() {
        _fontSize -= 2;
      });
      CacheHelper.saveData(key: 'quran_font_size', value: _fontSize);
    }
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

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final colorScheme = context.colorScheme;
    final surah = widget.surah;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'سورة ${surah.nameAr}',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isVerseByVerse = !_isVerseByVerse;
              });
            },
            icon: Icon(
              _isVerseByVerse ? Icons.menu_book_rounded : Icons.view_headline_rounded,
              color: colors.goldAccent,
            ),
            tooltip: _isVerseByVerse ? 'عرض متصل' : 'عرض آية بآية',
          ),
          IconButton(
            onPressed: _decreaseFontSize,
            icon: const Icon(Icons.text_decrease_rounded, size: 20),
            tooltip: 'تصغير الخط',
          ),
          IconButton(
            onPressed: _increaseFontSize,
            icon: const Icon(Icons.text_increase_rounded, size: 20),
            tooltip: 'تكبير الخط',
          ),
          IconButton(
            onPressed: _toggleAudio,
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: colors.goldAccent,
              size: 28,
            ),
            tooltip: _isPlaying ? 'إيقاف التلاوة' : 'استماع للتلاوة',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // Surah Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.navActiveBg,
                    colors.cardBg,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.goldAccent.withValues(alpha: 0.3), width: 1.2),
              ),
              child: Column(
                children: [
                  Text(
                    'سورة ${surah.nameAr}',
                    style: GoogleFonts.amiri(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: colors.goldAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${surah.isMakki ? "مكية" : "مدنية"} • ${_toArabic(surah.versesCount)} آيات • صفحة ${_toArabic(surah.verses.isNotEmpty ? surah.verses.first.page : 1)}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Basmala (except Surah At-Tawbah #9)
            if (surah.number != 9 && surah.number != 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Text(
                  'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: _fontSize + 4,
                    fontWeight: FontWeight.bold,
                    color: colors.goldAccent,
                    height: 1.8,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // Verse Rendering: Either Continuous Mushaf Style OR Card Style
            if (_isVerseByVerse)
              _buildVerseByVerseList(context, surah, colors, colorScheme)
            else
              _buildContinuousMushafView(context, surah, colors, colorScheme),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildContinuousMushafView(
    BuildContext context,
    Surah surah,
    AppCustomColors colors,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.cardBorder, width: 1.0),
      ),
      child: SelectableText.rich(
        TextSpan(
          children: surah.verses.map((verse) {
            return TextSpan(
              children: [
                TextSpan(
                  text: '${verse.textAr} ',
                  style: GoogleFonts.amiri(
                    fontSize: _fontSize,
                    height: 2.3,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '﴿${_toArabic(verse.number)}﴾ ',
                  style: GoogleFonts.amiri(
                    fontSize: _fontSize - 2,
                    fontWeight: FontWeight.bold,
                    color: colors.goldAccent,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildVerseByVerseList(
    BuildContext context,
    Surah surah,
    AppCustomColors colors,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: surah.verses.map((verse) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.cardBorder, width: 0.9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.goldAccent.withValues(alpha: 0.12),
                      border: Border.all(color: colors.goldAccent, width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        _toArabic(verse.number),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.goldAccent,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'جزء ${_toArabic(verse.juz)} • صفحة ${_toArabic(verse.page)}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                verse.textAr,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w600,
                  height: 2.2,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
