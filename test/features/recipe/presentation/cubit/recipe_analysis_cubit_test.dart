import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/recipe/domain/entities/nutrition_estimate.dart';
import 'package:foodify_cooking/features/recipe/domain/entities/recipe_analysis.dart';
import 'package:foodify_cooking/features/recipe/domain/repositories/recipe_analysis_repository.dart';
import 'package:foodify_cooking/features/recipe/domain/usecases/analyze_recipe_usecase.dart';
import 'package:foodify_cooking/features/recipe/presentation/cubit/recipe_analysis_cubit.dart';
import 'package:foodify_cooking/features/recipe/presentation/cubit/recipe_analysis_state.dart';

void main() {
  group('RecipeAnalysisCubit', () {
    late _FakeRepo repo;
    late RecipeAnalysisCubit cubit;

    setUp(() {
      repo = _FakeRepo();
      cubit = RecipeAnalysisCubit(
        analyzeRecipeUseCase: AnalyzeRecipeUseCase(repo),
      );
    });

    tearDown(() async => cubit.close());

    test('loadIfNeeded success emits loading then success with analysis',
        () async {
      repo.result = _sample();

      final transitions = expectLater(
        cubit.stream.map((s) => s.status),
        emitsInOrder([
          RecipeAnalysisStatus.loading,
          RecipeAnalysisStatus.success,
        ]),
      );

      await cubit.loadIfNeeded(recipeId: 'r-1', locale: 'en');
      await transitions;

      expect(cubit.state.status, RecipeAnalysisStatus.success);
      expect(cubit.state.analysis?.healthScore, 80);
      expect(cubit.state.errorMessage, isNull);
      expect(repo.calls, 1);
    });

    test('loadIfNeeded skips refetch when same recipe+locale already success',
        () async {
      repo.result = _sample();
      await cubit.loadIfNeeded(recipeId: 'r-1', locale: 'en');
      expect(repo.calls, 1);

      await cubit.loadIfNeeded(recipeId: 'r-1', locale: 'en');
      expect(repo.calls, 1);
    });

    test('loadIfNeeded refetches when locale changes', () async {
      repo.result = _sample();
      await cubit.loadIfNeeded(recipeId: 'r-1', locale: 'en');
      await cubit.loadIfNeeded(recipeId: 'r-1', locale: 'uz');
      expect(repo.calls, 2);
    });

    test('failure populates errorMessage and clears analysis flag', () async {
      repo.failureMessage = 'Gemini timeout';
      await cubit.loadIfNeeded(recipeId: 'r-1', locale: 'en');

      expect(cubit.state.status, RecipeAnalysisStatus.failure);
      expect(cubit.state.errorMessage, 'Gemini timeout');
      expect(cubit.state.analysis, isNull);
    });

    test('retry re-invokes the use case', () async {
      repo.failureMessage = 'Boom';
      await cubit.loadIfNeeded(recipeId: 'r-1', locale: 'en');
      expect(cubit.state.status, RecipeAnalysisStatus.failure);

      repo.failureMessage = null;
      repo.result = _sample();
      await cubit.retry();

      expect(cubit.state.status, RecipeAnalysisStatus.success);
      expect(repo.calls, 2);
    });
  });
}

RecipeAnalysis _sample() => const RecipeAnalysis(
      healthScore: 80,
      healthSummary: 'Balanced',
      disclaimer: 'AI estimate',
      cached: false,
      nutrition: NutritionEstimate(
        kcal: 420,
        proteinG: 12,
        carbsG: 55,
        fatG: 14,
      ),
    );

class _FakeRepo implements RecipeAnalysisRepository {
  RecipeAnalysis? result;
  String? failureMessage;
  int calls = 0;

  @override
  Future<Result<RecipeAnalysis>> analyze({
    required String recipeId,
    required String locale,
  }) async {
    calls += 1;
    final msg = failureMessage;
    if (msg != null) return Failure<RecipeAnalysis>(msg);
    return Success<RecipeAnalysis>(result!);
  }
}
