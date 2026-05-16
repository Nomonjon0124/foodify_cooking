import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_view.dart';
import '../repositories/profile_repository.dart';

class GetDemoProfileUseCase implements UseCase<ProfileView, NoParams> {
  GetDemoProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<ProfileView> call(NoParams params) {
    return _repository.getDemoProfile();
  }
}
