import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage_service.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._storageService) : super(const OnboardingState());

  final StorageService _storageService;

  void onPageChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> onCtaPressed({
    required PageController pageController,
    required VoidCallback onCompleted,
  }) async {
    if (state.isLastPage) {
      await _storageService.setString(StorageKeys.onboardingCompleted, 'true');
      onCompleted();
      return;
    }

    await pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
