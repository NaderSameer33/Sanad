import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          return MaterialApp(
            themeAnimationCurve: Curves.fastEaseInToSlowEaseOut,
            themeAnimationDuration: Duration(milliseconds: 750),
            debugShowCheckedModeBanner: false,
            title: 'سَنَد - Sanad',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: Scaffold(
              appBar: AppBar(
                title: const Text('سَـنَـد'),
                actions: [
                  IconButton(
                    icon: Icon(
                      state.isDarkMode
                          ? Icons.wb_sunny_outlined
                          : Icons.nightlight_round,
                    ),
                    onPressed: () {
                      getIt<ThemeCubit>().toggleTheme();
                    },
                    tooltip: state.isDarkMode
                        ? 'الوضع النهاري'
                        : 'الوضع السكيني (الليلي)',
                  ),
                ],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'سَـنَـد',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'رَفِيقُكَ فِي رِحْلَةِ القُرْآنِ وَالطَّمَأْنِينَة',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          getIt<ThemeCubit>().toggleTheme();
                        },
                        icon: Icon(
                          state.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        ),
                        label: Text(
                          state.isDarkMode
                              ? 'التبديل إلى الوضع النهاري'
                              : 'التبديل إلى الوضع الليلي',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
