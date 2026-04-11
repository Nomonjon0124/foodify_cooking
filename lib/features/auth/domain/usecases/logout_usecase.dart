import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<Result<void>, NoParams> {
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.logout();
  }
}
