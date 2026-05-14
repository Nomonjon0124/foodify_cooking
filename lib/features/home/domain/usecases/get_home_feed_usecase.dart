import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_feed.dart';
import '../repositories/home_repository.dart';

class GetHomeFeedUseCase implements UseCase<HomeFeed, NoParams> {
  GetHomeFeedUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<HomeFeed> call(NoParams params) {
    return _repository.getHomeFeed();
  }
}
