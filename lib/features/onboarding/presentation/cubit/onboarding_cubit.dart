import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void onPageChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> onCtaPressed({
    required PageController pageController,
    required VoidCallback onCompleted,
  }) async {
    if (state.isLastPage) {
      onCompleted();
      return;
    }

    await pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
