class QiblaState {
  final double qiblaDirection; // Angle towards Kaaba from true North (0..360)
  final double compassHeading; // Phone's magnetic/true heading (0..360)
  final String locationName;
  final double distanceKm;
  final bool isFacingQibla;
  final bool hasCompassSensor;

  const QiblaState({
    this.qiblaDirection = 245.0,
    this.compassHeading = 0.0,
    this.locationName = 'القاهرة، مصر',
    this.distanceKm = 1280.0,
    this.isFacingQibla = false,
    this.hasCompassSensor = true,
  });

  double get needleAngle => (qiblaDirection - compassHeading) * (3.141592653589793 / 180);

  QiblaState copyWith({
    double? qiblaDirection,
    double? compassHeading,
    String? locationName,
    double? distanceKm,
    bool? isFacingQibla,
    bool? hasCompassSensor,
  }) {
    return QiblaState(
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      compassHeading: compassHeading ?? this.compassHeading,
      locationName: locationName ?? this.locationName,
      distanceKm: distanceKm ?? this.distanceKm,
      isFacingQibla: isFacingQibla ?? this.isFacingQibla,
      hasCompassSensor: hasCompassSensor ?? this.hasCompassSensor,
    );
  }
}
