import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/services/cache_service.dart';
import '../models/athkar_models.dart';

abstract class AthkarRepository {
  Future<List<String>> getCategoryNames();
  Future<List<ThikrItem>> getAthkarByCategory(String category);
  Future<Map<String, List<ThikrItem>>> getAllAthkar();
  Future<int> getSavedCounter(String key);
  Future<void> saveCounter(String key, int value);
}

class AthkarRepositoryImpl implements AthkarRepository {
  Map<String, List<ThikrItem>>? _cachedData;

  @override
  Future<Map<String, List<ThikrItem>>> getAllAthkar() async {
    if (_cachedData != null) return _cachedData!;

    try {
      final jsonString = await rootBundle.loadString('assets/data/adkar.json');
      final Map<String, dynamic> rawMap = json.decode(jsonString);

      final Map<String, List<ThikrItem>> resultMap = {};
      rawMap.forEach((categoryName, itemsList) {
        if (itemsList is List) {
          resultMap[categoryName] = itemsList
              .map((item) => ThikrItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      });

      _cachedData = resultMap;
      return _cachedData!;
    } catch (e) {
      return {};
    }
  }

  @override
  Future<List<String>> getCategoryNames() async {
    final all = await getAllAthkar();
    return all.keys.toList();
  }

  @override
  Future<List<ThikrItem>> getAthkarByCategory(String category) async {
    final all = await getAllAthkar();
    return all[category] ?? [];
  }

  @override
  Future<int> getSavedCounter(String key) async {
    return (CacheHelper.getData(key: 'athkar_counter_$key') as int?) ?? 0;
  }

  @override
  Future<void> saveCounter(String key, int value) async {
    await CacheHelper.saveData(key: 'athkar_counter_$key', value: value);
  }
}
