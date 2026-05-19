import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/saved_recipes_repository.dart';

class GetSavedRecipeIdsUseCase
    implements UseCase<Result<Set<String>>, NoParams> {
  GetSavedRecipeIdsUseCase(this._repository);

  final SavedRecipesRepository _repository;

  @override
  Future<Result<Set<String>>> call(NoParams params) {
    return _repository.getSavedRecipeIds();
  }
}
