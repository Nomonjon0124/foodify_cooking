import 'package:equatable/equatable.dart';

import '../../domain/entities/recipe_analysis.dart';

enum RecipeAnalysisStatus { initial, loading, success, failure }

class RecipeAnalysisState extends Equatable {
  const RecipeAnalysisState({
    this.status = RecipeAnalysisStatus.initial,
    this.analysis,
    this.recipeId,
    this.locale,
    this.errorMessage,
  });

  final RecipeAnalysisStatus status;
  final RecipeAnalysis? analysis;
  final String? recipeId;
  final String? locale;
  final String? errorMessage;

  RecipeAnalysisState copyWith({
    RecipeAnalysisStatus? status,
    RecipeAnalysis? analysis,
    String? recipeId,
    String? locale,
    String? errorMessage,
    bool clearError = false,
    bool clearAnalysis = false,
  }) {
    return RecipeAnalysisState(
      status: status ?? this.status,
      analysis: clearAnalysis ? null : (analysis ?? this.analysis),
      recipeId: recipeId ?? this.recipeId,
      locale: locale ?? this.locale,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, analysis, recipeId, locale, errorMessage];
}
