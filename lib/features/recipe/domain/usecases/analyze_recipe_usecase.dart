import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/recipe_analysis.dart';
import '../repositories/recipe_analysis_repository.dart';

class AnalyzeRecipeUseCase
    implements UseCase<Result<RecipeAnalysis>, AnalyzeRecipeParams> {
  AnalyzeRecipeUseCase(this._repository);

  final RecipeAnalysisRepository _repository;

  @override
  Future<Result<RecipeAnalysis>> call(AnalyzeRecipeParams params) {
    return _repository.analyze(
      recipeId: params.recipeId,
      locale: params.locale,
    );
  }
}

class AnalyzeRecipeParams extends Equatable {
  const AnalyzeRecipeParams({required this.recipeId, required this.locale});

  final String recipeId;
  final String locale;

  @override
  List<Object?> get props => [recipeId, locale];
}
