import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/resend_confirmation_email_usecase.dart';
import 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit(this._resendUseCase) : super(const VerifyEmailState());

  final ResendConfirmationEmailUseCase _resendUseCase;

  Future<void> resend({required String email}) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return;
    emit(state.copyWith(status: VerifyEmailStatus.loading));
    final response = await _resendUseCase(
      ResendConfirmationEmailParams(email: trimmed),
    );
    response.fold(
      (message) => emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
          errorMessage: message,
        ),
      ),
      (_) => emit(state.copyWith(status: VerifyEmailStatus.success)),
    );
  }
}
