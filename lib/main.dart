import 'package:flutter/material.dart';
import 'package:sanad/core/services/cache_service.dart';
import 'package:sanad/sanad_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  runApp(const SanadApp());
}
