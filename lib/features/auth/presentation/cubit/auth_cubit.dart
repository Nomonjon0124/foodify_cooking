import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthState());

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final response = await _getCurrentUserUseCase(const NoParams());
    response.fold(
      (message) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: message,
        ),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final response = await _logoutUseCase(const NoParams());
    response.fold(
      (message) => emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: message),
      ),
      (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
    );
  }
}
