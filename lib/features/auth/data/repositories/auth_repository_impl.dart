import '../../../../core/network/network_info.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required TokenService tokenService,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _tokenService = tokenService,
       _networkInfo = networkInfo;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final TokenService _tokenService;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Failure<UserEntity>('No internet connection');
      }

      final response = await _remoteDataSource.login(
        LoginRequestModel(email: email, password: password),
      );
      await _tokenService.saveToken(response.token);
      await _localDataSource.cacheUser(response.user);
      return Success<UserEntity>(response.user);
    } catch (_) {
      return const Failure<UserEntity>('Unable to login');
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Success<UserEntity>(cachedUser);
      }

      if (!await _networkInfo.isConnected) {
        return const Failure<UserEntity>('No internet connection');
      }

      final user = await _remoteDataSource.getCurrentUser();
      await _localDataSource.cacheUser(user);
      return Success<UserEntity>(user);
    } catch (_) {
      return const Failure<UserEntity>('Unable to fetch current user');
    }
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
}
