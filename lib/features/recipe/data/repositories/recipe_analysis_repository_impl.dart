import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/recipe_analysis.dart';
import '../../domain/repositories/recipe_analysis_repository.dart';
import '../data_sources/recipe_analysis_remote_data_source.dart';

class RecipeAnalysisRepositoryImpl implements RecipeAnalysisRepository {
  RecipeAnalysisRepositoryImpl(this._remoteDataSource);

  final RecipeAnalysisRemoteDataSource _remoteDataSource;

  @override
  Future<Result<RecipeAnalysis>> analyze({
    required String recipeId,
    required String locale,
  }) async {
    try {
      final analysis = await _remoteDataSource.analyze(
        recipeId: recipeId,
        locale: locale,
      );
      return Success<RecipeAnalysis>(analysis);
    } on FunctionException catch (error) {
      final detail = error.details;
      final msg = detail is String && detail.isNotEmpty
          ? detail
          : (error.reasonPhrase ?? 'AI analysis failed');
      return Failure<RecipeAnalysis>(msg);
    } on AuthException catch (error) {
      return Failure<RecipeAnalysis>(error.message);
    } on FormatException catch (error) {
      return Failure<RecipeAnalysis>(error.message);
    } catch (_) {
      return const Failure<RecipeAnalysis>('Unable to analyze recipe');
    }
  }
}
