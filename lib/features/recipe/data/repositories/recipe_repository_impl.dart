import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/recipe_detail.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../data_sources/recipe_detail_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this._remoteDataSource);

  final RecipeDetailRemoteDataSource _remoteDataSource;

  @override
  Future<Result<RecipeDetail>> getRecipeDetail(String recipeId) async {
    try {
      final detail = await _remoteDataSource.getRecipeDetail(recipeId);
      return Success<RecipeDetail>(detail);
    } on AuthException catch (error) {
      return Failure<RecipeDetail>(error.message);
    } on PostgrestException catch (error) {
      return Failure<RecipeDetail>(error.message);
    } catch (_) {
      return const Failure<RecipeDetail>('Unable to load recipe');
    }
  }

  @override
  Future<Result<RecipeLikeToggle>> toggleLike(String recipeId) async {
    try {
      final result = await _remoteDataSource.toggleLike(recipeId);
      return Success<RecipeLikeToggle>(
        RecipeLikeToggle(
          isLiked: result.isLiked,
          likesCount: result.likesCount,
        ),
      );
    } on AuthException catch (error) {
      return Failure<RecipeLikeToggle>(error.message);
    } on PostgrestException catch (error) {
      return Failure<RecipeLikeToggle>(error.message);
    } catch (_) {
      return const Failure<RecipeLikeToggle>('Unable to update like');
    }
  }
}
