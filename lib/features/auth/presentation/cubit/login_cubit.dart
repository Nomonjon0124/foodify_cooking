import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUseCase) : super(const LoginState());

  final LoginUseCase _loginUseCase;

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final response = await _loginUseCase(
      LoginParams(email: email.trim(), password: password.trim()),
    );
    response.fold(
      (message) => emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: message),
      ),
      (user) => emit(state.copyWith(status: LoginStatus.success, user: user)),
    );
  }
}
