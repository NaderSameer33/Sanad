import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/reciter_models.dart';

abstract class RecitersRepository {
  Future<List<Reciter>> getAllReciters();
  Future<List<Reciter>> searchReciters(String query);
  Future<Reciter?> getReciterById(int id);
}

class RecitersRepositoryImpl implements RecitersRepository {
  List<Reciter>? _cachedReciters;

  @override
  Future<List<Reciter>> getAllReciters() async {
    if (_cachedReciters != null) return _cachedReciters!;

    try {
      final jsonString = await rootBundle.loadString('assets/data/soundsjson.json');
      final Map<String, dynamic> rawMap = json.decode(jsonString);
      final List<dynamic> recitersList = rawMap['reciters'] as List<dynamic>? ?? [];

      _cachedReciters = recitersList
          .map((item) => Reciter.fromJson(item as Map<String, dynamic>))
          .where((r) => r.name.isNotEmpty && r.moshafList.isNotEmpty)
          .toList();

      return _cachedReciters!;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Reciter>> searchReciters(String query) async {
    final all = await getAllReciters();
    if (query.trim().isEmpty) return all;

    final cleanQuery = _normalizeArabic(query.trim());
    return all.where((r) {
      final cleanName = _normalizeArabic(r.name);
      return cleanName.contains(cleanQuery);
    }).toList();
  }

  @override
  Future<Reciter?> getReciterById(int id) async {
    final all = await getAllReciters();
    return all.cast<Reciter?>().firstWhere(
          (r) => r?.id == id,
          orElse: () => null,
        );
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }
}
