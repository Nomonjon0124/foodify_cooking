import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../home/domain/entities/home_feed.dart';
import '../repositories/saved_recipes_repository.dart';

class GetSavedRecipesUseCase
    implements UseCase<Result<List<HomeRecipe>>, NoParams> {
  GetSavedRecipesUseCase(this._repository);

  final SavedRecipesRepository _repository;

  @override
  Future<Result<List<HomeRecipe>>> call(NoParams params) {
    return _repository.getSavedRecipes();
  }
}
