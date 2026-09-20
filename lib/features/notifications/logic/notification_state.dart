import '../data/models/notification_settings_model.dart';

class NotificationState {
  final NotificationSettings settings;
  final bool isLoading;
  final bool testSent;

  const NotificationState({
    this.settings = const NotificationSettings(),
    this.isLoading = true,
    this.testSent = false,
  });

  NotificationState copyWith({
    NotificationSettings? settings,
    bool? isLoading,
    bool? testSent,
  }) {
    return NotificationState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      testSent: testSent ?? this.testSent,
    );
  }
}
