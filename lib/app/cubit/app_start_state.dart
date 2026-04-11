import 'package:equatable/equatable.dart';

enum AppStartStatus { initial, loading, ready, failure }

class AppStartState extends Equatable {
  const AppStartState({
    this.status = AppStartStatus.initial,
    this.errorMessage,
  });

  final AppStartStatus status;
  final String? errorMessage;

  AppStartState copyWith({AppStartStatus? status, String? errorMessage}) {
    return AppStartState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
