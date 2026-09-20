import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sanad/core/routing/app_router.dart';
import 'core/services/di.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/logic/theme_cubit.dart';
import 'core/theme/logic/theme_state.dart';

class SanadApp extends StatelessWidget {
  const SanadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: appRouter,
            themeAnimationCurve: Curves.fastEaseInToSlowEaseOut,
            themeAnimationDuration: const Duration(milliseconds: 750),
            debugShowCheckedModeBanner: false,
            title: 'سَنَد - Sanad',
            locale: const Locale('ar'),
            supportedLocales: const [
              Locale('ar'),
              Locale('ar', 'EG'),
              Locale('ar', 'SA'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child ?? const SizedBox.shrink(),
              );
            },
            theme: AppTheme.getTheme(
              brightness: Brightness.light,
              period: state.activePrayerTheme,
            ),
            darkTheme: AppTheme.getTheme(
              brightness: Brightness.dark,
              period: state.activePrayerTheme,
            ),
            themeMode: state.themeMode,
          );
        },
      ),
    );
  }
}
