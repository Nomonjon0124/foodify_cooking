import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/analyze_recipe_usecase.dart';
import 'recipe_analysis_state.dart';

class RecipeAnalysisCubit extends Cubit<RecipeAnalysisState> {
  RecipeAnalysisCubit({required AnalyzeRecipeUseCase analyzeRecipeUseCase})
    : _analyzeRecipeUseCase = analyzeRecipeUseCase,
      super(const RecipeAnalysisState());

  final AnalyzeRecipeUseCase _analyzeRecipeUseCase;

  Future<void> loadIfNeeded({
    required String recipeId,
    required String locale,
  }) async {
    final isSameRequest =
        state.recipeId == recipeId && state.locale == locale;
    if (isSameRequest &&
        (state.status == RecipeAnalysisStatus.loading ||
            state.status == RecipeAnalysisStatus.success)) {
      return;
    }

    emit(
      state.copyWith(
        status: RecipeAnalysisStatus.loading,
        recipeId: recipeId,
        locale: locale,
        clearError: true,
        clearAnalysis: !isSameRequest,
      ),
    );

    final result = await _analyzeRecipeUseCase(
      AnalyzeRecipeParams(recipeId: recipeId, locale: locale),
    );

    result.fold(
      (message) => emit(
        state.copyWith(
          status: RecipeAnalysisStatus.failure,
          errorMessage: message,
        ),
      ),
      (analysis) => emit(
        state.copyWith(
          status: RecipeAnalysisStatus.success,
          analysis: analysis,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> retry() async {
    final id = state.recipeId;
    final loc = state.locale;
    if (id == null || loc == null) return;
    emit(state.copyWith(status: RecipeAnalysisStatus.initial));
    await loadIfNeeded(recipeId: id, locale: loc);
  }
}
