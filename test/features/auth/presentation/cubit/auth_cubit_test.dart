import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/constants/storage_keys.dart';
import 'package:foodify_cooking/core/services/storage_service.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/auth/domain/auth_failure_messages.dart';
import 'package:foodify_cooking/features/auth/domain/entities/user_entity.dart';
import 'package:foodify_cooking/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/logout_usecase.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/auth_state.dart';

void main() {
  group('AuthCubit', () {
    late _FakeAuthRepository repository;
    late StorageService storage;
    late AuthCubit cubit;

    setUp(() {
      repository = _FakeAuthRepository();
      storage = StorageService();
      cubit = AuthCubit(
        authRepository: repository,
        getCurrentUserUseCase: GetCurrentUserUseCase(repository),
        logoutUseCase: LogoutUseCase(repository),
        signInWithGoogleUseCase: SignInWithGoogleUseCase(repository),
        storageService: storage,
      );
    });

    tearDown(() async {
      await cubit.close();
      await repository.close();
    });

    test('initializes from current user and reacts to auth stream', () async {
      repository.currentUser = _FakeAuthRepository.user;

      await cubit.initialize();
      expect(cubit.state.status, AuthStatus.authenticated);
      expect(cubit.state.user, _FakeAuthRepository.user);

      repository.emitUser(null);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.status, AuthStatus.unauthenticated);
      expect(cubit.state.user, isNull);
    });

    test('stores pending route before starting Google sign in', () async {
      await cubit.signInWithGoogle(returnTo: '/save');

      expect(repository.googleRedirectTo, 'foodify-cooking://login-callback');
      expect(storage.getString(StorageKeys.pendingAuthRoute), '/save');
      expect(cubit.state.pendingRoute, '/save');
    });

    test(
      'maps OAuth callback stream errors and clears pending route',
      () async {
        await storage.setString(StorageKeys.pendingAuthRoute, '/save');
        await cubit.initialize();

        repository.emitError(
          Exception('Unable to exchange external code: 4/OA'),
        );
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.status, AuthStatus.failure);
        expect(
          cubit.state.errorMessage,
          AuthFailureMessages.googleCallbackFailed,
        );
        expect(cubit.state.pendingRoute, isNull);
        expect(storage.getString(StorageKeys.pendingAuthRoute), isNull);
      },
    );

    test(
      'handles callback failure from router and clears pending route',
      () async {
        await storage.setString(StorageKeys.pendingAuthRoute, '/save');

        await cubit.handleAuthCallbackFailure(
          AuthFailureMessages.googleCallbackFailed,
        );

        expect(cubit.state.status, AuthStatus.failure);
        expect(
          cubit.state.errorMessage,
          AuthFailureMessages.googleCallbackFailed,
        );
        expect(cubit.state.pendingRoute, isNull);
        expect(storage.getString(StorageKeys.pendingAuthRoute), isNull);
      },
    );

    test('logout clears authenticated state', () async {
      repository.currentUser = _FakeAuthRepository.user;
      await cubit.initialize();

      await cubit.logout();

      expect(cubit.state.status, AuthStatus.unauthenticated);
      expect(cubit.state.user, isNull);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  static const user = UserEntity(
    id: 'user-1',
    email: 'cook@test.local',
    name: 'Cook Tester',
  );

  final _controller = StreamController<UserEntity?>.broadcast();
  UserEntity? currentUser;
  String? googleRedirectTo;

  void emitUser(UserEntity? user) {
    currentUser = user;
    _controller.add(user);
  }

  void emitError(Object error) {
    _controller.addError(error, StackTrace.current);
  }

  Future<void> close() => _controller.close();

  @override
  Stream<UserEntity?> authStateChanges() => _controller.stream;

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    return Success<UserEntity?>(currentUser);
  }

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    currentUser = user;
    return const Success<UserEntity>(user);
  }

  @override
  Future<Result<void>> logout() async {
    currentUser = null;
    return const Success<void>(null);
  }

  @override
  Future<Result<UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    currentUser = user;
    return const Success<UserEntity>(user);
  }

  @override
  Future<Result<void>> signInWithGoogle({required String redirectTo}) async {
    googleRedirectTo = redirectTo;
    return const Success<void>(null);
  }
}
