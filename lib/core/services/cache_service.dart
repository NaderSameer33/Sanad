import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  CacheHelper._();

  /// Initializes the single SharedPreferences instance at app startup.
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Get generic dynamic data by key.b 
  static dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  /// Get a String value by key.
  static String? getString({required String key}) {
    return _sharedPreferences.getString(key);
  }

  /// Get a bool value by key.
  static bool? getBool({required String key}) {
    return _sharedPreferences.getBool(key);
  }

  /// Get an int value by key.
  static int? getInt({required String key}) {
    return _sharedPreferences.getInt(key);
  }

  /// Get a double value by key.
  static double? getDouble({required String key}) {
    return _sharedPreferences.getDouble(key);
  }

  /// Get a `List<String>` by key.
  static List<String>? getStringList({required String key}) {
    return _sharedPreferences.getStringList(key);
  }

  /// Save any supported data type (String, int, bool, double, `List<String>`).
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);
    if (value is double) return await _sharedPreferences.setDouble(key, value);
    if (value is List<String>) {
      return await _sharedPreferences.setStringList(key, value);
    }
    return false;
  }

  /// Remove a specific entry by key.
  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  /// Clear all cached data.
  static Future<bool> clearAll() async {
    return await _sharedPreferences.clear();
  }

  /// Check if a key exists in cache.
  static bool containsKey({required String key}) {
    return _sharedPreferences.containsKey(key);
  }
}
