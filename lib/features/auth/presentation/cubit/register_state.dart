import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

enum RegisterStatus { initial, loading, success, confirmationRequired, failure }

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.user,
    this.pendingConfirmationEmail,
    this.errorMessage,
  });

  final RegisterStatus status;
  final UserEntity? user;
  final String? pendingConfirmationEmail;
  final String? errorMessage;

  RegisterState copyWith({
    RegisterStatus? status,
    UserEntity? user,
    String? pendingConfirmationEmail,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      user: user ?? this.user,
      pendingConfirmationEmail:
          pendingConfirmationEmail ?? this.pendingConfirmationEmail,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    pendingConfirmationEmail,
    errorMessage,
  ];
}
