import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  Timer? _timer;

  void start() {
    emit(state.copyWith(status: SplashStatus.running));
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      emit(state.copyWith(status: SplashStatus.completed));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
