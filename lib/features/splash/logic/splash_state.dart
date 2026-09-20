class SplashState {
  final double progress;
  final String statusMessage;
  final bool isCompleted;

  const SplashState({
    required this.progress,
    required this.statusMessage,
    this.isCompleted = false,
  });

  factory SplashState.initial() {
    return const SplashState(
      progress: 0.15,
      statusMessage: 'جاري تهيئة المصحف الشريف والأذكار...',
      isCompleted: false,
    );
  }

  SplashState copyWith({
    double? progress,
    String? statusMessage,
    bool? isCompleted,
  }) {
    return SplashState(
      progress: progress ?? this.progress,
      statusMessage: statusMessage ?? this.statusMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
