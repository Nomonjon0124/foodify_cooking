import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  const OnboardingState({this.currentIndex = 0, this.totalPages = 3});

  final int currentIndex;
  final int totalPages;

  bool get isLastPage => currentIndex == totalPages - 1;

  OnboardingState copyWith({int? currentIndex, int? totalPages}) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [currentIndex, totalPages];
}
