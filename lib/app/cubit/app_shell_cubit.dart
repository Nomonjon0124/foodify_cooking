import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_shell_state.dart';

class AppShellCubit extends Cubit<AppShellState> {
  AppShellCubit() : super(const AppShellState());

  void setCurrentIndex(int index) {
    if (index == state.currentIndex) return;
    emit(state.copyWith(currentIndex: index));
  }
}
