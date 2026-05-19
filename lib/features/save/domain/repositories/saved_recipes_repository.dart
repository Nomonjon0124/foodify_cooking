import '../../../../core/utils/result.dart';
import '../../../home/domain/entities/home_feed.dart';

abstract interface class SavedRecipesRepository {
  Future<Result<List<HomeRecipe>>> getSavedRecipes();
  Future<Result<Set<String>>> getSavedRecipeIds();
  Future<Result<void>> saveRecipe(String recipeId);
  Future<Result<void>> unsaveRecipe(String recipeId);
}
