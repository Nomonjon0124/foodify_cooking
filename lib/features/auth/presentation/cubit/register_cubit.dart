import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/auth_failure_messages.dart';
import '../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerUseCase) : super(const RegisterState());

  final RegisterUseCase _registerUseCase;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    final response = await _registerUseCase(
      RegisterParams(
        name: name.trim(),
        email: email.trim(),
        password: password.trim(),
      ),
    );
    response.fold(
      (message) {
        final requiresConfirmation =
            message == AuthFailureMessages.emailNotConfirmed ||
            message.toLowerCase().contains('confirm');
        emit(
          state.copyWith(
            status: requiresConfirmation
                ? RegisterStatus.confirmationRequired
                : RegisterStatus.failure,
            errorMessage: message,
          ),
        );
      },
      (user) =>
          emit(state.copyWith(status: RegisterStatus.success, user: user)),
    );
  }
}
