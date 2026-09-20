import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/athkar_models.dart';

class AthkarCategoryDetailView extends StatefulWidget {
  final String categoryTitle;
  final List<ThikrItem> items;

  const AthkarCategoryDetailView({
    super.key,
    required this.categoryTitle,
    required this.items,
  });

  @override
  State<AthkarCategoryDetailView> createState() => _AthkarCategoryDetailViewState();
}

class _AthkarCategoryDetailViewState extends State<AthkarCategoryDetailView> {
  late List<int> _remainingCounts;

  @override
  void initState() {
    super.initState();
    _remainingCounts = widget.items.map((e) => e.targetCount).toList();
  }

  void _decrementCount(int index) {
    if (_remainingCounts[index] > 0) {
      HapticFeedback.lightImpact();
      setState(() {
        _remainingCounts[index]--;
      });
    }
  }

  void _resetItem(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _remainingCounts[index] = widget.items[index].targetCount;
    });
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

    final completedCount = _remainingCounts.where((c) => c == 0).length;
    final total = widget.items.length;
    final progress = total > 0 ? completedCount / total : 0.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.categoryTitle,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إجمالي الإنجاز',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${_toArabic(completedCount)} من ${_toArabic(total)} أذكار',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.goldAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: colors.cardBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.goldAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Athkar List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final remaining = _remainingCounts[index];
                final isDone = remaining == 0;

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isDone ? colors.navActiveBg.withValues(alpha: 0.5) : colors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDone
                          ? colors.goldAccent.withValues(alpha: 0.4)
                          : colors.cardBorder,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dhikr Content
                      SelectableText(
                        item.content,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          height: 1.9,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),

                      if (item.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colors.goldAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],

                      const SizedBox(height: 14),

                      // Actions Row: Count button, Reset, and Copy
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: item.content));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم نسخ الذكر إلى الحافظة'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.copy_rounded,
                                  size: 18,
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                                tooltip: 'نسخ الذكر',
                              ),
                              if (isDone)
                                IconButton(
                                  onPressed: () => _resetItem(index),
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                  tooltip: 'إعادة التكرار',
                                ),
                            ],
                          ),

                          // Interactive Countdown Button
                          GestureDetector(
                            onTap: () => _decrementCount(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDone ? Colors.green.withValues(alpha: 0.2) : colors.navActiveBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDone ? Colors.green : colors.goldAccent,
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isDone ? Icons.check_circle_rounded : Icons.touch_app_rounded,
                                    size: 18,
                                    color: isDone ? Colors.green : colors.goldAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isDone
                                        ? 'اكتمل'
                                        : '${_toArabic(remaining)} / ${_toArabic(item.targetCount)}',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isDone ? Colors.green : colors.navActiveContent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
