import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/auth_failure_messages.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository authRepository,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required StorageService storageService,
  }) : _authRepository = authRepository,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _logoutUseCase = logoutUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase,
       _storageService = storageService,
       super(const AuthState());

  final AuthRepository _authRepository;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final StorageService _storageService;
  StreamSubscription<UserEntity?>? _authSubscription;

  Future<void> initialize() async {
    _authSubscription ??= _authRepository.authStateChanges().listen(
      (user) {
        final pendingRoute = _storageService.getString(
          StorageKeys.pendingAuthRoute,
        );
        emit(
          AuthState(
            status: user == null
                ? AuthStatus.unauthenticated
                : AuthStatus.authenticated,
            user: user,
            pendingRoute: pendingRoute,
          ),
        );
      },
      onError: (Object error, _) {
        unawaited(_storageService.remove(StorageKeys.pendingAuthRoute));
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: _authStreamFailureMessage(error),
            pendingRoute: null,
          ),
        );
      },
    );
    await checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final response = await _getCurrentUserUseCase(const NoParams());
    response.fold(
      (message) => emit(
        AuthState(
          status: AuthStatus.unauthenticated,
          errorMessage: message,
          pendingRoute: _storageService.getString(StorageKeys.pendingAuthRoute),
        ),
      ),
      (user) => emit(
        AuthState(
          status: user == null
              ? AuthStatus.unauthenticated
              : AuthStatus.authenticated,
          user: user,
          pendingRoute: _storageService.getString(StorageKeys.pendingAuthRoute),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle({String? returnTo}) async {
    if (returnTo != null && returnTo.trim().isNotEmpty) {
      await _storageService.setString(
        StorageKeys.pendingAuthRoute,
        returnTo.trim(),
      );
    }
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
        pendingRoute: returnTo ?? state.pendingRoute,
      ),
    );
    final response = await _signInWithGoogleUseCase(
      const SignInWithGoogleParams(
        redirectTo: 'foodify-cooking://login-callback',
      ),
    );
    response.fold(
      (message) => emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: message),
      ),
      (_) {},
    );
  }

  Future<void> clearPendingRoute() async {
    await _storageService.remove(StorageKeys.pendingAuthRoute);
    emit(state.copyWith(pendingRoute: null));
  }

  Future<void> handleAuthCallbackFailure(String message) async {
    await _storageService.remove(StorageKeys.pendingAuthRoute);
    emit(
      state.copyWith(
        status: AuthStatus.failure,
        errorMessage: message,
        pendingRoute: null,
      ),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final response = await _logoutUseCase(const NoParams());
    response.fold(
      (message) => emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: message),
      ),
      (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
    );
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }

  String _authStreamFailureMessage(Object error) {
    final normalized = '$error'.toLowerCase();
    if (normalized.contains('unable to exchange external code') ||
        normalized.contains('server_error') ||
        normalized.contains('unexpected_failure')) {
      return AuthFailureMessages.googleCallbackFailed;
    }
    return AuthFailureMessages.googleSignInFailed;
  }
}
