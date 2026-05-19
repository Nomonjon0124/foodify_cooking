import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/config/routes/route_names.dart';
import 'package:foodify_cooking/core/constants/storage_keys.dart';
import 'package:foodify_cooking/core/services/storage_service.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/auth/domain/entities/register_outcome.dart';
import 'package:foodify_cooking/features/auth/domain/entities/user_entity.dart';
import 'package:foodify_cooking/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/logout_usecase.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/auth_cubit.dart';

void main() {
  late _FakeAuthRepository repository;
  late StorageService storage;
  late AuthCubit cubit;

  setUp(() async {
    repository = _FakeAuthRepository();
    storage = StorageService();
    cubit = AuthCubit(
      authRepository: repository,
      getCurrentUserUseCase: GetCurrentUserUseCase(repository),
      logoutUseCase: LogoutUseCase(repository),
      signInWithGoogleUseCase: SignInWithGoogleUseCase(repository),
      storageService: storage,
    );
    await cubit.initialize();
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test(
    'Google auth returns to the pending profile route and clears it',
    () async {
      await cubit.signInWithGoogle(returnTo: RouteNames.profile);

      expect(repository.googleRedirectTo, 'foodify-cooking://login-callback');
      expect(
        storage.getString(StorageKeys.pendingAuthRoute),
        RouteNames.profile,
      );
      expect(cubit.state.pendingRoute, RouteNames.profile);

      repository.emitUser(_FakeAuthRepository.user);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.isAuthenticated, isTrue);
      expect(cubit.state.pendingRoute, RouteNames.profile);

      final routeToOpenAfterLogin = cubit.state.pendingRoute;
      await cubit.clearPendingRoute();

      expect(routeToOpenAfterLogin, RouteNames.profile);
      expect(storage.getString(StorageKeys.pendingAuthRoute), isNull);
      expect(cubit.state.pendingRoute, isNull);
    },
  );
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
  Future<Result<RegisterOutcome>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    currentUser = user;
    return const Success<RegisterOutcome>(RegisterSignedIn(user));
  }

  @override
  Future<Result<void>> resendConfirmation({required String email}) async {
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> signInWithGoogle({required String redirectTo}) async {
    googleRedirectTo = redirectTo;
    return const Success<void>(null);
  }
}
