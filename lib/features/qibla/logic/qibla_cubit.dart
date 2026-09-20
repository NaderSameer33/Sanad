import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/location_service.dart';
import 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  final LocationService _locationService;
  StreamSubscription<CompassEvent>? _compassSub;
  bool _lastFacing = false;

  static const double makkahLat = 21.422487;
  static const double makkahLng = 39.826206;

  QiblaCubit(this._locationService) : super(const QiblaState()) {
    initQibla();
  }

  Future<void> initQibla() async {
    try {
      final userLoc = await _locationService.determinePosition();
      final coordinates = Coordinates(userLoc.latitude, userLoc.longitude);
      final qibla = Qibla(coordinates);
      final qAngle = qibla.direction;

      final distMeters = Geolocator.distanceBetween(
        userLoc.latitude,
        userLoc.longitude,
        makkahLat,
        makkahLng,
      );
      final distKm = distMeters / 1000;

      emit(
        state.copyWith(
          qiblaDirection: qAngle,
          locationName: userLoc.displayName,
          distanceKm: distKm,
        ),
      );

      _startCompassListener();
    } catch (_) {
      _startCompassListener();
    }
  }

  void _startCompassListener() {
    _compassSub?.cancel();

    if (FlutterCompass.events == null) {
      emit(state.copyWith(hasCompassSensor: false));
      return;
    }

    _compassSub = FlutterCompass.events!.listen((event) {
      final heading = event.heading ?? 0.0;
      final diff = (state.qiblaDirection - heading).abs();
      final isFacing = diff < 4.0 || (360 - diff) < 4.0;

      if (isFacing && !_lastFacing) {
        HapticFeedback.heavyImpact();
      }
      _lastFacing = isFacing;

      emit(
        state.copyWith(
          compassHeading: heading,
          isFacingQibla: isFacing,
          hasCompassSensor: true,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _compassSub?.cancel();
    return super.close();
  }
}
