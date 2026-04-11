import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class GetHomeFeedUseCase implements UseCase<List<String>, NoParams> {
  GetHomeFeedUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<List<String>> call(NoParams params) {
    return _repository.getFeaturedCollections();
  }
}
