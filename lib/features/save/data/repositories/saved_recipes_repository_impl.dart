import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/result.dart';
import '../../../home/domain/entities/home_feed.dart';
import '../../domain/repositories/saved_recipes_repository.dart';
import '../data_sources/saved_recipes_remote_data_source.dart';

class SavedRecipesRepositoryImpl implements SavedRecipesRepository {
  SavedRecipesRepositoryImpl(this._remoteDataSource);

  final SavedRecipesRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<HomeRecipe>>> getSavedRecipes() async {
    try {
      return Success<List<HomeRecipe>>(
        await _remoteDataSource.getSavedRecipes(),
      );
    } on AuthException catch (error) {
      return Failure<List<HomeRecipe>>(error.message);
    } catch (_) {
      return const Failure<List<HomeRecipe>>('Unable to load saved recipes');
    }
  }

  @override
  Future<Result<Set<String>>> getSavedRecipeIds() async {
    try {
      return Success<Set<String>>(await _remoteDataSource.getSavedRecipeIds());
    } on AuthException catch (error) {
      return Failure<Set<String>>(error.message);
    } catch (_) {
      return const Failure<Set<String>>('Unable to load saved recipes');
    }
  }

  @override
  Future<Result<void>> saveRecipe(String recipeId) async {
    try {
      await _remoteDataSource.saveRecipe(recipeId);
      return const Success<void>(null);
    } on AuthException catch (error) {
      return Failure<void>(error.message);
    } catch (_) {
      return const Failure<void>('Unable to save recipe');
    }
  }

  @override
  Future<Result<void>> unsaveRecipe(String recipeId) async {
    try {
      await _remoteDataSource.unsaveRecipe(recipeId);
      return const Success<void>(null);
    } on AuthException catch (error) {
      return Failure<void>(error.message);
    } catch (_) {
      return const Failure<void>('Unable to remove saved recipe');
    }
  }
}
