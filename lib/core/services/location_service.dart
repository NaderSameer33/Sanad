import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'cache_service.dart';

class UserLocation {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
  });

  String get displayName => '$cityName، $countryName';

  static const UserLocation cairoDefault = UserLocation(
    latitude: 30.0444,
    longitude: 31.2357,
    cityName: 'القاهرة',
    countryName: 'مصر',
  );
}

class LocationService {
  static const String _keyLat = 'cached_lat';
  static const String _keyLng = 'cached_lng';
  static const String _keyCity = 'cached_city';
  static const String _keyCountry = 'cached_country';

  const LocationService();

  /// Get current user location with automatic permission request and cached fallback
  Future<UserLocation> determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return getCachedOrDefault();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return getCachedOrDefault();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return getCachedOrDefault();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 7),
        ),
      );

      String city = 'القاهرة';
      String country = 'مصر';

      try {
        List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          city = p.locality?.isNotEmpty == true
              ? p.locality!
              : (p.subAdministrativeArea?.isNotEmpty == true
                  ? p.subAdministrativeArea!
                  : (p.administrativeArea ?? 'المدينة'));
          country = p.country?.isNotEmpty == true ? p.country! : 'مصر';
        }
      } catch (e) {
        debugPrint('Geocoding error: $e');
      }

      final location = UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: city,
        countryName: country,
      );

      // Cache for offline use
      await _cacheLocation(location);

      return location;
    } catch (e) {
      debugPrint('Location determination error: $e');
      return getCachedOrDefault();
    }
  }

  Future<void> _cacheLocation(UserLocation loc) async {
    await CacheHelper.saveData(key: _keyLat, value: loc.latitude);
    await CacheHelper.saveData(key: _keyLng, value: loc.longitude);
    await CacheHelper.saveData(key: _keyCity, value: loc.cityName);
    await CacheHelper.saveData(key: _keyCountry, value: loc.countryName);
  }

  UserLocation getCachedOrDefault() {
    final lat = CacheHelper.getData(key: _keyLat) as double?;
    final lng = CacheHelper.getData(key: _keyLng) as double?;
    final city = CacheHelper.getData(key: _keyCity) as String?;
    final country = CacheHelper.getData(key: _keyCountry) as String?;

    if (lat != null && lng != null && city != null && country != null) {
      return UserLocation(
        latitude: lat,
        longitude: lng,
        cityName: city,
        countryName: country,
      );
    }

    return UserLocation.cairoDefault;
  }
}
