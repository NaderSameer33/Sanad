import 'package:get_it/get_it.dart';
import '../theme/logic/theme_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<ThemeCubit>(ThemeCubit());
}
