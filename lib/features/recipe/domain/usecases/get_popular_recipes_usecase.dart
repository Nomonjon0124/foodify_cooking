import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/recipe_repository.dart';

class GetPopularRecipesUseCase implements UseCase<List<String>, NoParams> {
  GetPopularRecipesUseCase(this._repository);

  final RecipeRepository _repository;

  @override
  Future<List<String>> call(NoParams params) {
    return _repository.getPopularRecipes();
  }
}
