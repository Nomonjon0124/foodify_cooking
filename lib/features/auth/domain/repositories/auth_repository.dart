import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<UserEntity>> getCurrentUser();
}
