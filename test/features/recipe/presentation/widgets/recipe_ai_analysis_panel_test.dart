import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/services/storage_service.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/recipe/domain/entities/nutrition_estimate.dart';
import 'package:foodify_cooking/features/recipe/domain/entities/recipe_analysis.dart';
import 'package:foodify_cooking/features/recipe/domain/repositories/recipe_analysis_repository.dart';
import 'package:foodify_cooking/features/recipe/domain/usecases/analyze_recipe_usecase.dart';
import 'package:foodify_cooking/features/recipe/presentation/cubit/recipe_analysis_cubit.dart';
import 'package:foodify_cooking/features/recipe/presentation/widgets/recipe_ai_analysis_panel.dart';
import 'package:foodify_cooking/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:foodify_cooking/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('panel shows loading text then success card', (tester) async {
    final repo = _ControlledRepo();
    final cubit = RecipeAnalysisCubit(
      analyzeRecipeUseCase: AnalyzeRecipeUseCase(repo),
    );
    final settings = SettingsCubit(StorageService());

    await tester.pumpWidget(
      _Harness(
        cubit: cubit,
        settings: settings,
        child: const RecipeAiAnalysisPanel(recipeId: 'r-1'),
      ),
    );

    await tester.pump();
    expect(find.text('Analyzing recipe with AI…'), findsOneWidget);

    repo.complete(_sample());
    await tester.pumpAndSettle();

    expect(find.text('Health score'), findsOneWidget);
    expect(find.text('Nutrition per serving (estimated)'), findsOneWidget);
    expect(find.text('420 kcal'), findsOneWidget);
    expect(find.text('12 g protein'), findsOneWidget);
    expect(find.textContaining('Balanced'), findsOneWidget);

    await cubit.close();
    await settings.close();
  });

  testWidgets('panel shows error with retry button on failure',
      (tester) async {
    final repo = _ControlledRepo();
    final cubit = RecipeAnalysisCubit(
      analyzeRecipeUseCase: AnalyzeRecipeUseCase(repo),
    );
    final settings = SettingsCubit(StorageService());

    await tester.pumpWidget(
      _Harness(
        cubit: cubit,
        settings: settings,
        child: const RecipeAiAnalysisPanel(recipeId: 'r-1'),
      ),
    );

    await tester.pump();
    repo.fail('Gemini quota exceeded');
    await tester.pumpAndSettle();

    expect(find.textContaining('Gemini quota exceeded'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);

    await cubit.close();
    await settings.close();
  });
}

RecipeAnalysis _sample() => const RecipeAnalysis(
      healthScore: 80,
      healthSummary: 'Balanced meal with vegetables.',
      disclaimer: 'AI estimate only.',
      cached: false,
      nutrition: NutritionEstimate(
        kcal: 420,
        proteinG: 12,
        carbsG: 55,
        fatG: 14,
      ),
    );

class _Harness extends StatelessWidget {
  const _Harness({
    required this.cubit,
    required this.settings,
    required this.child,
  });

  final RecipeAnalysisCubit cubit;
  final SettingsCubit settings;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider<RecipeAnalysisCubit>.value(value: cubit),
                BlocProvider<SettingsCubit>.value(value: settings),
              ],
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _ControlledRepo implements RecipeAnalysisRepository {
  final _completer = Completer<Result<RecipeAnalysis>>();

  void complete(RecipeAnalysis analysis) =>
      _completer.complete(Success<RecipeAnalysis>(analysis));

  void fail(String message) =>
      _completer.complete(Failure<RecipeAnalysis>(message));

  @override
  Future<Result<RecipeAnalysis>> analyze({
    required String recipeId,
    required String locale,
  }) {
    return _completer.future;
  }
}
