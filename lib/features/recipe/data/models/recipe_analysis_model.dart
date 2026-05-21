import '../../domain/entities/nutrition_estimate.dart';
import '../../domain/entities/recipe_analysis.dart';

class RecipeAnalysisModel extends RecipeAnalysis {
  const RecipeAnalysisModel({
    required super.healthScore,
    required super.healthSummary,
    required super.nutrition,
    required super.disclaimer,
    required super.cached,
  });

  factory RecipeAnalysisModel.fromInvokeResponse(Map<String, dynamic> body) {
    final analysis = body['analysis'];
    if (analysis is! Map) {
      throw FormatException('analyze-recipe: missing analysis object');
    }
    final analysisMap = Map<String, dynamic>.from(analysis);
    final nutritionRaw = analysisMap['nutrition_per_serving'];
    if (nutritionRaw is! Map) {
      throw const FormatException('analyze-recipe: missing nutrition object');
    }
    final nutritionMap = Map<String, dynamic>.from(nutritionRaw);

    return RecipeAnalysisModel(
      healthScore: (analysisMap['health_score'] as num).round(),
      healthSummary: analysisMap['health_summary'] as String,
      disclaimer: analysisMap['disclaimer'] as String,
      cached: body['cached'] == true,
      nutrition: NutritionEstimate(
        kcal: _toDouble(nutritionMap['kcal']),
        proteinG: _toDouble(nutritionMap['protein_g']),
        carbsG: _toDouble(nutritionMap['carbs_g']),
        fatG: _toDouble(nutritionMap['fat_g']),
      ),
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    throw FormatException('analyze-recipe: nutrition value not numeric: $value');
  }
}
