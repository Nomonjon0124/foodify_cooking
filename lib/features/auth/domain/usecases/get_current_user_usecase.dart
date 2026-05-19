import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<Result<UserEntity?>, NoParams> {
  GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
