import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../logic/athkar_cubit.dart';
import '../../logic/athkar_state.dart';

class AnimatedSmartTasbeehWidget extends StatefulWidget {
  final AthkarState state;
  final AthkarCubit cubit;

  const AnimatedSmartTasbeehWidget({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  State<AnimatedSmartTasbeehWidget> createState() => _AnimatedSmartTasbeehWidgetState();
}

class _AnimatedSmartTasbeehWidgetState extends State<AnimatedSmartTasbeehWidget>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;

  late AnimationController _rotationController;
  double _currentRotation = 0.0;
  int _targetGoal = 33; // 33 or 100 or 0 (unlimited)

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Haptic feedback
    HapticFeedback.selectionClick();

    // Tap scale bounce
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });

    // Animate rotation of beads
    final stepAngle = (2 * math.pi) / 33;
    setState(() {
      _currentRotation += stepAngle;
    });

    widget.cubit.incrementTasbeeh();

    // Check target reached
    final currentCount = widget.state.tasbeehCount + 1;
    if (_targetGoal > 0 && currentCount % _targetGoal == 0) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ما شاء الله! أتممت $_targetGoal تسبيحة بنجاح 🌿',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF2E6B47),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
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
    final currentPhrase = AthkarCubit.tasbeehPhrases[widget.state.selectedTasbeehDhikrIndex];
    final count = widget.state.tasbeehCount;

    final progress = _targetGoal > 0 ? (count % _targetGoal) / _targetGoal : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          // 1. Phrase Selector Horizontal List
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: AthkarCubit.tasbeehPhrases.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = widget.state.selectedTasbeehDhikrIndex == index;
                final phrase = AthkarCubit.tasbeehPhrases[index];

                return GestureDetector(
                  onTap: () => widget.cubit.switchTasbeehDhikr(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.navActiveBg : colors.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? colors.goldAccent : colors.cardBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        phrase,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? colors.navActiveContent : colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // 2. Active Dhikr Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.navActiveBg, colors.cardBg],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.goldAccent.withValues(alpha: 0.3), width: 1.2),
            ),
            child: Text(
              currentPhrase,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. Goal Selector Chips (33 / 100 / مفتوح)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGoalChip(33, '٣٣ تسبيحة'),
              const SizedBox(width: 8),
              _buildGoalChip(100, '١٠٠ تسبيحة'),
              const SizedBox(width: 8),
              _buildGoalChip(0, 'تسبيح مفتوح'),
            ],
          ),

          const SizedBox(height: 30),

          // 4. Interactive Animated Rosary Counter Circle
          GestureDetector(
            onTap: _handleTap,
            child: AnimatedBuilder(
              animation: _bounceController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating Beads Ring Custom Painter
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: _currentRotation),
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        builder: (context, rot, child) {
                          return CustomPaint(
                            size: const Size(260, 260),
                            painter: _BeadsRingPainter(
                              rotation: rot,
                              activeColor: colors.goldAccent,
                              inactiveColor: colors.cardBorder,
                              beadCount: 33,
                            ),
                          );
                        },
                      ),

                      // Progress Ring
                      if (_targetGoal > 0)
                        SizedBox(
                          width: 204,
                          height: 204,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 3.5,
                            backgroundColor: colors.cardBorder.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(colors.goldAccent),
                          ),
                        ),

                      // Central Counter Button Disk
                      Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.cardBg,
                          border: Border.all(
                            color: colors.goldAccent.withValues(alpha: 0.4),
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.goldAccent.withValues(alpha: 0.18),
                              blurRadius: 36,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _toArabic(count),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                                color: colors.goldAccent,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _targetGoal > 0 ? 'من ${_toArabic(_targetGoal)}' : 'اضغط للتسبيح',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 36),

          // 5. Bottom Action Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  widget.cubit.resetTasbeeh();
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('تصفير العداد'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.onSurface.withValues(alpha: 0.8),
                  side: BorderSide(color: colors.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildGoalChip(int goal, String label) {
    final colors = context.customColors;
    final theme = Theme.of(context);
    final isSelected = _targetGoal == goal;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      selectedColor: theme.colorScheme.primary,
      backgroundColor: colors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(
        color: isSelected ? theme.colorScheme.primary : colors.cardBorder,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _targetGoal = goal;
          });
        }
      },
    );
  }
}

class _BeadsRingPainter extends CustomPainter {
  final double rotation;
  final Color activeColor;
  final Color inactiveColor;
  final int beadCount;

  _BeadsRingPainter({
    required this.rotation,
    required this.activeColor,
    required this.inactiveColor,
    required this.beadCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final angleStep = (2 * math.pi) / beadCount;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < beadCount; i++) {
      final angle = (i * angleStep) + rotation;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final isLeaderBead = i == 0;
      paint.color = isLeaderBead ? activeColor : inactiveColor;
      canvas.drawCircle(Offset(x, y), isLeaderBead ? 5.5 : 3.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BeadsRingPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
