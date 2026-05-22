import 'package:equatable/equatable.dart';

import 'nutrition_estimate.dart';

class RecipeAnalysis extends Equatable {
  const RecipeAnalysis({
    required this.healthScore,
    required this.healthSummary,
    required this.nutrition,
    required this.disclaimer,
    required this.cached,
  });

  final int healthScore;
  final String healthSummary;
  final NutritionEstimate nutrition;
  final String disclaimer;
  final bool cached;

  @override
  List<Object?> get props => [
    healthScore,
    healthSummary,
    nutrition,
    disclaimer,
    cached,
  ];
}
