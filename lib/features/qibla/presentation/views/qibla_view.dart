import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/di.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../logic/qibla_cubit.dart';
import '../../logic/qibla_state.dart';

class QiblaView extends StatelessWidget {
  const QiblaView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QiblaCubit(getIt<LocationService>()),
      child: const _QiblaViewContent(),
    );
  }
}

class _QiblaViewContent extends StatelessWidget {
  const _QiblaViewContent();

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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'بوصلة القبلة',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<QiblaCubit, QiblaState>(
        builder: (context, state) {
          final needleRotation = state.needleAngle;
          final isFacing = state.isFacingQibla;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              children: [
                // Direction Status Banner
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isFacing
                        ? Colors.green.withValues(alpha: 0.15)
                        : colors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isFacing ? Colors.green : colors.cardBorder,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFacing ? Icons.check_circle_rounded : Icons.explore_rounded,
                        color: isFacing ? Colors.green : colors.goldAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isFacing
                            ? 'أنت الآن تواجه القبلة بدقة 🕋'
                            : 'وجّه الهاتف حتى تشير الإبرة للكعبة',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isFacing ? Colors.green : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Compass Dial Circle
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Compass Outer Dial Ring
                      Container(
                        width: 270,
                        height: 270,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.cardBg,
                          border: Border.all(
                            color: isFacing
                                ? Colors.green
                                : colors.goldAccent.withValues(alpha: 0.6),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isFacing ? Colors.green : colors.goldAccent)
                                  .withValues(alpha: 0.12),
                              blurRadius: 32,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                      ),

                      // Compass Cardinal Points (Static Dial)
                      Positioned(
                        top: 14,
                        child: Text(
                          'ش',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: isFacing ? Colors.green : Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 14,
                        child: Text(
                          'ج',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 18,
                        child: Text(
                          'ق',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        child: Text(
                          'غ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Rotating Needle & Kaaba Pointer
                      Transform.rotate(
                        angle: needleRotation,
                        child: SizedBox(
                          width: 240,
                          height: 240,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pointer Line
                              Container(
                                width: 3,
                                height: 160,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      colors.goldAccent,
                                      colors.goldAccent.withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),

                              // Kaaba Icon at the tip
                              Positioned(
                                top: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isFacing ? Colors.green : colors.goldAccent,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isFacing ? Colors.green : colors.goldAccent)
                                            .withValues(alpha: 0.4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    '🕋',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),

                              // Center Pin
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.goldAccent,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Info Cards (Bento 3 tiles)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: colors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.near_me_rounded, color: colors.goldAccent, size: 20),
                            const SizedBox(height: 6),
                            Text(
                              'زاوية القبلة',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              '${_toArabic(state.qiblaDirection.toInt())}°',
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.goldAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: colors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.straighten_rounded, color: colors.goldAccent, size: 20),
                            const SizedBox(height: 6),
                            Text(
                              'المسافة لمكة',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              '${_toArabic(state.distanceKm.toInt())} كم',
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.goldAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Location Details Tile
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: colors.goldAccent, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الموقع المعتمد للحساب',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              state.locationName,
                              style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Calibration Tip
                Text(
                  '💡 تأكد من الابتعاد عن الأجهزة المعدنية والمغناطيسية للحصول على أدق نتيجة.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
