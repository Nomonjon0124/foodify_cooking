import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_view.dart';
import '../repositories/profile_repository.dart';

class GetCurrentProfileUseCase implements UseCase<ProfileView, NoParams> {
  GetCurrentProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<ProfileView> call(NoParams params) {
    return _repository.getCurrentProfile();
  }
}
