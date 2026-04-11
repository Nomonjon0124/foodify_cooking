import 'package:equatable/equatable.dart';

class AppShellState extends Equatable {
  const AppShellState({this.currentIndex = 0});

  final int currentIndex;

  AppShellState copyWith({int? currentIndex}) {
    return AppShellState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
