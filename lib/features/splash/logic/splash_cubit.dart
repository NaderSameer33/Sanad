import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  Timer? _timer;

  SplashCubit() : super(SplashState.initial());

  void startInitialization() {
    int step = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 650), (timer) {
      step++;
      if (step == 1) {
        emit(state.copyWith(
          progress: 0.55,
          statusMessage: 'ضَبْطُ مَوَاقِيتِ الصَّلَاةِ وَاتِّجَاهِ القِبْلَة...',
        ));
      } else if (step == 2) {
        emit(state.copyWith(
          progress: 0.94,
          statusMessage: 'نُورٌ وَطُمَأْنِينَة...',
        ));
      } else if (step >= 3) {
        timer.cancel();
        emit(state.copyWith(
          progress: 1.0,
          statusMessage: 'اكتملت التهيئة',
          isCompleted: true,
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
