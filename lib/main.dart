import 'package:flutter/material.dart';
import 'package:sanad/core/services/cache_service.dart';
import 'package:sanad/core/services/di.dart';
import 'package:sanad/sanad_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await setupServiceLocator();
  runApp(const SanadApp());
}
