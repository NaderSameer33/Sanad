import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/di.dart';
import '../../../../core/theme/app_custom_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/repos/notification_repository.dart';
import '../../logic/notification_cubit.dart';
import '../../logic/notification_state.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/prayer_time_service.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(
        repository: getIt<NotificationRepository>(),
        notificationService: getIt<NotificationService>(),
        locationService: getIt<LocationService>(),
        prayerTimeService: getIt<PrayerTimeService>(),
      ),
      child: const _NotificationsViewBody(),
    );
  }
}

class _NotificationsViewBody extends StatelessWidget {
  const _NotificationsViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'التنبيهات والأذان',
          style: AppTextStyles.headlineMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state.testSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'تم إرسال إشعار الأذان لهاتفك الآن بنجاح! 🔔',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<NotificationCubit>();
          final settings = state.settings;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Test Notification Hero Card
              _buildTestNotificationCard(context, cubit),
              const SizedBox(height: 24),

              // Prayer Times Section
              _buildSectionHeader(context, 'مواقيت الصلوات والأذان', Icons.mosque_rounded),
              const SizedBox(height: 12),
              _buildCardContainer(
                context,
                children: [
                  _buildNotificationSwitchTile(
                    context: context,
                    title: 'أذان الفجر',
                    subtitle: 'تنبيه بصوت الأذان لموعد صلاة الفجر',
                    icon: Icons.wb_twilight_rounded,
                    value: settings.fajr,
                    onChanged: (val) => cubit.toggleFajr(val),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildNotificationSwitchTile(
                    context: context,
                    title: 'أذان الظهر',
                    subtitle: 'تنبيه بصوت الأذان لموعد صلاة الظهر',
                    icon: Icons.wb_sunny_rounded,
                    value: settings.dhuhr,
                    onChanged: (val) => cubit.toggleDhuhr(val),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildNotificationSwitchTile(
                    context: context,
                    title: 'أذان العصر',
                    subtitle: 'تنبيه بصوت الأذان لموعد صلاة العصر',
                    icon: Icons.filter_drama_rounded,
                    value: settings.asr,
                    onChanged: (val) => cubit.toggleAsr(val),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildNotificationSwitchTile(
                    context: context,
                    title: 'أذان المغرب',
                    subtitle: 'تنبيه بصوت الأذان لموعد صلاة المغرب',
                    icon: Icons.nights_stay_rounded,
                    value: settings.maghrib,
                    onChanged: (val) => cubit.toggleMaghrib(val),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildNotificationSwitchTile(
                    context: context,
                    title: 'أذان العشاء',
                    subtitle: 'تنبيه بصوت الأذان لموعد صلاة العشاء',
                    icon: Icons.bedtime_rounded,
                    value: settings.isha,
                    onChanged: (val) => cubit.toggleIsha(val),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Athkar & Sunan Section
              _buildSectionHeader(context, 'الأذكار والسنن النبوية', Icons.auto_stories_rounded),
              const SizedBox(height: 12),
              _buildCardContainer(
                context,
                children: [
                  _buildNotificationSwitchTile(
                    context: context,
                    title: 'أذكار الصباح',
                    subtitle: 'تذكير يومي في الساعة ٧:٠٠ صباحاً',
                    icon: Icons.light_mode_rounded,
                    value: settings.morningAthkar,
                    onChanged: (val) => cubit.toggleMorningAthkar(val),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildNotificationSwitchTile(
                    context: context,
                    title: 'أذكار المساء',
                    subtitle: 'تذكير يومي في الساعة ٥:٠٠ مساءً',
                    icon: Icons.dark_mode_rounded,
                    value: settings.eveningAthkar,
                    onChanged: (val) => cubit.toggleEveningAthkar(val),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildNotificationSwitchTile(
                    context: context,
                    title: 'سورة الكهف يوم الجمعة',
                    subtitle: 'تذكير أسبوعي صباح كل جمعة لقراءة سورة الكهف',
                    icon: Icons.menu_book_rounded,
                    value: settings.fridayKahf,
                    onChanged: (val) => cubit.toggleFridayKahf(val),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sound Type Section
              _buildSectionHeader(context, 'نوع صوت التنبيه', Icons.volume_up_rounded),
              const SizedBox(height: 12),
              _buildCardContainer(
                context,
                children: [
                  _buildSoundOptionTile(
                    context: context,
                    title: 'الأذان كاملاً',
                    subtitle: 'تشغيل صوت الأذان كاملاً عند دخول وقت الصلاة',
                    selected: settings.soundType == 'adhan',
                    onTap: () => cubit.changeSoundType('adhan'),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSoundOptionTile(
                    context: context,
                    title: 'التكبير فقط (الله أكبر)',
                    subtitle: 'تشغيل تكبيرتين عند دخول وقت الصلاة',
                    selected: settings.soundType == 'takbeer',
                    onTap: () => cubit.changeSoundType('takbeer'),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSoundOptionTile(
                    context: context,
                    title: 'نغمة هادئة',
                    subtitle: 'تنبيه هادئ ومختصر مع اهتزاز خفيف',
                    selected: settings.soundType == 'gentle',
                    onTap: () => cubit.changeSoundType('gentle'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTestNotificationCard(BuildContext context, NotificationCubit cubit) {
    final theme = Theme.of(context);
    final colors = context.customColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اختبار التنبيه الفوري',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'جرّب وصول إشعار الأذان والصوت الآن على هاتفك',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => cubit.sendTestNotification(),
              icon: const Icon(Icons.send_rounded, size: 20, color: Colors.white),
              label: Text(
                'إرسال إشعار تجريبي الآن',
                style: AppTextStyles.titleSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer(BuildContext context, {required List<Widget> children}) {
    final colors = context.customColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildNotificationSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: theme.colorScheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSoundOptionTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.3),
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
