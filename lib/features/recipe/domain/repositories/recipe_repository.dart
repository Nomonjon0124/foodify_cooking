import '../../../../core/utils/result.dart';
import '../entities/recipe_detail.dart';

abstract interface class RecipeRepository {
  Future<Result<RecipeDetail>> getRecipeDetail(String recipeId);

  /// Toggles the like state for the current user. Returns the new total
  /// likes count for the recipe.
  Future<Result<RecipeLikeToggle>> toggleLike(String recipeId);
}

class RecipeLikeToggle {
  const RecipeLikeToggle({required this.isLiked, required this.likesCount});

  final bool isLiked;
  final int likesCount;
}
