import '../../../../core/utils/result.dart';
import '../entities/register_outcome.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<RegisterOutcome>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> resendConfirmation({required String email});

  Future<Result<void>> signInWithGoogle({required String redirectTo});

  Future<Result<void>> logout();

  Future<Result<UserEntity?>> getCurrentUser();

  Stream<UserEntity?> authStateChanges();
}
