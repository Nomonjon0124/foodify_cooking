import '../../../../core/utils/result.dart';
import '../entities/recipe_analysis.dart';

abstract interface class RecipeAnalysisRepository {
  Future<Result<RecipeAnalysis>> analyze({
    required String recipeId,
    required String locale,
  });
}
