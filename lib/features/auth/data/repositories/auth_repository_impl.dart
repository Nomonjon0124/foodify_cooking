import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/auth_failure_messages.dart';
import '../../domain/repositories/auth_repository.dart';
import '../auth_error_mapper.dart';
import '../auth_log_redactor.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required TokenService tokenService,
    required NetworkInfo networkInfo,
    required LoggerService logger,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _tokenService = tokenService,
       _networkInfo = networkInfo,
       _logger = logger;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final TokenService _tokenService;
  final NetworkInfo _networkInfo;
  final LoggerService _logger;

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        _logger.log(
          'Auth repository login blocked reason=network '
          'email=${AuthLogRedactor.email(email)}',
        );
        return const Failure<UserEntity>(AuthFailureMessages.network);
      }

      final response = await _remoteDataSource.login(
        LoginRequestModel(email: email, password: password),
      );
      await _tokenService.saveToken(response.token);
      await _localDataSource.cacheUser(response.user);
      return Success<UserEntity>(response.user);
    } on AuthException catch (error) {
      final mapped = AuthErrorMapper.mapAuthException(
        error,
        operation: AuthOperation.login,
      );
      _logAuthException(
        operation: 'login',
        mapped: mapped,
        error: error,
        email: email,
      );
      return Failure<UserEntity>(mapped);
    } catch (error) {
      final mapped = AuthErrorMapper.mapUnknown(
        error,
        operation: AuthOperation.login,
      );
      _logUnknownAuthFailure(
        operation: 'login',
        mapped: mapped,
        error: error,
        email: email,
      );
      return Failure<UserEntity>(mapped);
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        _logger.log(
          'Auth repository register blocked reason=network '
          'email=${AuthLogRedactor.email(email)}',
        );
        return const Failure<UserEntity>(AuthFailureMessages.network);
      }

      final response = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      await _tokenService.saveToken(response.token);
      await _localDataSource.cacheUser(response.user);
      return Success<UserEntity>(response.user);
    } on AuthException catch (error) {
      final mapped = AuthErrorMapper.mapAuthException(
        error,
        operation: AuthOperation.register,
      );
      _logAuthException(
        operation: 'register',
        mapped: mapped,
        error: error,
        email: email,
      );
      return Failure<UserEntity>(mapped);
    } catch (error) {
      final mapped = AuthErrorMapper.mapUnknown(
        error,
        operation: AuthOperation.register,
      );
      _logUnknownAuthFailure(
        operation: 'register',
        mapped: mapped,
        error: error,
        email: email,
      );
      return Failure<UserEntity>(mapped);
    }
  }

  @override
  Future<Result<void>> signInWithGoogle({required String redirectTo}) async {
    try {
      if (!await _networkInfo.isConnected) {
        _logger.log('Auth repository googleSignIn blocked reason=network');
        return const Failure<void>(AuthFailureMessages.network);
      }

      await _remoteDataSource.signInWithGoogle(redirectTo: redirectTo);
      return const Success<void>(null);
    } on AuthException catch (error) {
      final mapped = AuthErrorMapper.mapAuthException(
        error,
        operation: AuthOperation.googleSignIn,
      );
      _logAuthException(
        operation: 'googleSignIn',
        mapped: mapped,
        error: error,
      );
      return Failure<void>(mapped);
    } catch (error) {
      final mapped = AuthErrorMapper.mapUnknown(
        error,
        operation: AuthOperation.googleSignIn,
      );
      _logUnknownAuthFailure(
        operation: 'googleSignIn',
        mapped: mapped,
        error: error,
      );
      return Failure<void>(mapped);
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      if (user == null) {
        await _localDataSource.clear();
        await _tokenService.clearToken();
        return const Success<UserEntity?>(null);
      }

      await _syncToken();
      await _localDataSource.cacheUser(user);
      return Success<UserEntity?>(user);
    } catch (_) {
      return const Failure<UserEntity?>('Unable to fetch current user');
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _remoteDataSource.authStateChanges().asyncMap((user) async {
      if (user == null) {
        await _localDataSource.clear();
        await _tokenService.clearToken();
        return null;
      }

      await _syncToken();
      await _localDataSource.cacheUser(user);
      return user;
    });
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clear();
      await _tokenService.clearToken();
      return const Success<void>(null);
    } catch (_) {
      return const Failure<void>('Unable to logout');
    }
  }

  Future<void> _syncToken() async {
    final token = _remoteDataSource.getCurrentAccessToken();
    if (token == null || token.isEmpty) {
      await _tokenService.clearToken();
      return;
    }
    await _tokenService.saveToken(token);
  }

  void _logAuthException({
    required String operation,
    required String mapped,
    required AuthException error,
    String? email,
  }) {
    _logger.log(
      'Auth repository failure operation=$operation '
      '${email == null ? '' : 'email=${AuthLogRedactor.email(email)} '}'
      'mapped=$mapped ${AuthLogRedactor.authException(error)}',
    );
  }

  void _logUnknownAuthFailure({
    required String operation,
    required String mapped,
    required Object error,
    String? email,
  }) {
    _logger.log(
      'Auth repository failure operation=$operation '
      '${email == null ? '' : 'email=${AuthLogRedactor.email(email)} '}'
      'mapped=$mapped ${AuthLogRedactor.object(error)}',
    );
  }
}
