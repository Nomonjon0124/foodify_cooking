import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/network/network_info.dart';
import 'package:foodify_cooking/core/services/logger_service.dart';
import 'package:foodify_cooking/core/services/storage_service.dart';
import 'package:foodify_cooking/core/services/token_service.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:foodify_cooking/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:foodify_cooking/features/auth/data/data_sources/register_remote_result.dart';
import 'package:foodify_cooking/features/auth/data/models/auth_response_model.dart';
import 'package:foodify_cooking/features/auth/data/models/login_request_model.dart';
import 'package:foodify_cooking/features/auth/data/models/user_model.dart';
import 'package:foodify_cooking/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:foodify_cooking/features/auth/domain/auth_failure_messages.dart';
import 'package:foodify_cooking/features/auth/domain/entities/register_outcome.dart';
import 'package:foodify_cooking/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late _FakeAuthRemoteDataSource remoteDataSource;
    late _FakeAuthLocalDataSource localDataSource;
    late TokenService tokenService;
    late _FakeNetworkInfo networkInfo;
    late List<String> logs;
    late AuthRepositoryImpl repository;

    setUp(() {
      remoteDataSource = _FakeAuthRemoteDataSource();
      localDataSource = _FakeAuthLocalDataSource();
      tokenService = TokenService(StorageService());
      networkInfo = _FakeNetworkInfo();
      logs = <String>[];
      repository = AuthRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        tokenService: tokenService,
        networkInfo: networkInfo,
        logger: LoggerService(logSink: logs.add),
      );
    });

    test(
      'maps Google provider-disabled errors and logs redacted details',
      () async {
        remoteDataSource.googleError = const AuthException(
          'Unsupported provider: provider is not enabled',
          statusCode: '400',
          code: 'validation_failed',
        );

        final result = await repository.signInWithGoogle(
          redirectTo: 'foodify-cooking://login-callback',
        );

        expect(result, isA<Failure<void>>());
        expect(
          (result as Failure<void>).message,
          AuthFailureMessages.googleProviderDisabled,
        );
        expect(
          logs.any(
            (line) =>
                line.contains('operation=googleSignIn') &&
                line.contains(
                  'mapped=${AuthFailureMessages.googleProviderDisabled}',
                ) &&
                line.contains('code=validation_failed'),
          ),
          isTrue,
        );
      },
    );

    test(
      'maps invalid email login credentials and redacts email in logs',
      () async {
        remoteDataSource.loginError = const AuthException(
          'Invalid login credentials',
          statusCode: '400',
          code: 'invalid_credentials',
        );

        final result = await repository.login(
          email: 'demo@example.com',
          password: 'super-secret',
        );

        expect(result, isA<Failure<UserEntity>>());
        expect(
          (result as Failure<UserEntity>).message,
          AuthFailureMessages.invalidCredentials,
        );
        final joinedLogs = logs.join('\n');
        expect(joinedLogs, contains('email=d***@example.com'));
        expect(joinedLogs, isNot(contains('demo@example.com')));
        expect(joinedLogs, isNot(contains('super-secret')));
      },
    );

    test(
      'register returns RegisterSignedIn when remote yields a session',
      () async {
        remoteDataSource.registerResult = const RegisterRemoteSignedIn(
          AuthResponseModel(
            token: 'tok',
            user: _FakeAuthRemoteDataSource.user,
          ),
        );

        final result = await repository.register(
          name: 'Demo',
          email: 'demo@example.com',
          password: 'super-secret',
        );

        expect(result, isA<Success<RegisterOutcome>>());
        final outcome = (result as Success<RegisterOutcome>).data;
        expect(outcome, isA<RegisterSignedIn>());
        expect((outcome as RegisterSignedIn).user.email, 'demo@example.com');
        expect(localDataSource.cachedUser?.id, 'user-1');
      },
    );

    test(
      'register returns RegisterNeedsConfirmation when session is absent',
      () async {
        remoteDataSource.registerResult = const RegisterRemoteNeedsConfirmation(
          'demo@example.com',
        );

        final result = await repository.register(
          name: 'Demo',
          email: 'demo@example.com',
          password: 'super-secret',
        );

        expect(result, isA<Success<RegisterOutcome>>());
        final outcome = (result as Success<RegisterOutcome>).data;
        expect(outcome, isA<RegisterNeedsConfirmation>());
        expect(
          (outcome as RegisterNeedsConfirmation).email,
          'demo@example.com',
        );
        expect(localDataSource.cachedUser, isNull);
      },
    );

    test(
      'resendConfirmation maps user_already_confirmed to a dedicated key',
      () async {
        remoteDataSource.resendError = const AuthException(
          'User already confirmed',
          statusCode: '422',
          code: 'user_already_confirmed',
        );

        final result = await repository.resendConfirmation(
          email: 'demo@example.com',
        );

        expect(result, isA<Failure<void>>());
        expect(
          (result as Failure<void>).message,
          AuthFailureMessages.resendUserAlreadyConfirmed,
        );
      },
    );

    test(
      'resendConfirmation maps rate-limit responses to resendRateLimited',
      () async {
        remoteDataSource.resendError = const AuthException(
          'Email rate limit exceeded',
          statusCode: '429',
          code: 'over_email_send_rate_limit',
        );

        final result = await repository.resendConfirmation(
          email: 'demo@example.com',
        );

        expect(result, isA<Failure<void>>());
        expect(
          (result as Failure<void>).message,
          AuthFailureMessages.resendRateLimited,
        );
      },
    );
  });
}

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  static const user = UserModel(
    id: 'user-1',
    email: 'demo@example.com',
    name: 'Demo',
  );

  AuthException? loginError;
  AuthException? googleError;
  AuthException? resendError;
  RegisterRemoteResult registerResult = const RegisterRemoteSignedIn(
    AuthResponseModel(token: 'token', user: user),
  );

  @override
  Stream<UserModel?> authStateChanges() => const Stream<UserModel?>.empty();

  @override
  String? getCurrentAccessToken() => 'token';

  @override
  Future<UserModel?> getCurrentUser() async => null;

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    final error = loginError;
    if (error != null) throw error;
    return const AuthResponseModel(token: 'token', user: user);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<RegisterRemoteResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return registerResult;
  }

  @override
  Future<void> resendConfirmation({required String email}) async {
    final error = resendError;
    if (error != null) throw error;
  }

  @override
  Future<void> signInWithGoogle({required String redirectTo}) async {
    final error = googleError;
    if (error != null) throw error;
  }
}

class _FakeAuthLocalDataSource implements AuthLocalDataSource {
  UserModel? cachedUser;

  @override
  Future<void> cacheUser(UserModel user) async {
    cachedUser = user;
  }

  @override
  Future<void> clear() async {
    cachedUser = null;
  }

  @override
  Future<UserModel?> getCachedUser() async => cachedUser;
}

class _FakeNetworkInfo implements NetworkInfo {
  bool connected = true;

  @override
  Future<bool> get isConnected async => connected;
}
