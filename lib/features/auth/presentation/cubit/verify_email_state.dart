import 'package:equatable/equatable.dart';

enum VerifyEmailStatus { initial, loading, success, failure }

class VerifyEmailState extends Equatable {
  const VerifyEmailState({
    this.status = VerifyEmailStatus.initial,
    this.errorMessage,
  });

  final VerifyEmailStatus status;
  final String? errorMessage;

  VerifyEmailState copyWith({
    VerifyEmailStatus? status,
    String? errorMessage,
  }) {
    return VerifyEmailState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
