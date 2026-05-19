import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../../home/domain/entities/home_feed.dart';
import '../../domain/usecases/get_saved_recipe_ids_usecase.dart';
import '../../domain/usecases/get_saved_recipes_usecase.dart';
import '../../domain/usecases/save_recipe_usecase.dart';
import '../../domain/usecases/unsave_recipe_usecase.dart';
import 'saved_recipes_state.dart';

class SavedRecipesCubit extends Cubit<SavedRecipesState> {
  SavedRecipesCubit({
    required GetSavedRecipesUseCase getSavedRecipesUseCase,
    required GetSavedRecipeIdsUseCase getSavedRecipeIdsUseCase,
    required SaveRecipeUseCase saveRecipeUseCase,
    required UnsaveRecipeUseCase unsaveRecipeUseCase,
  }) : _getSavedRecipesUseCase = getSavedRecipesUseCase,
       _getSavedRecipeIdsUseCase = getSavedRecipeIdsUseCase,
       _saveRecipeUseCase = saveRecipeUseCase,
       _unsaveRecipeUseCase = unsaveRecipeUseCase,
       super(const SavedRecipesState());

  final GetSavedRecipesUseCase _getSavedRecipesUseCase;
  final GetSavedRecipeIdsUseCase _getSavedRecipeIdsUseCase;
  final SaveRecipeUseCase _saveRecipeUseCase;
  final UnsaveRecipeUseCase _unsaveRecipeUseCase;

  Future<void> loadSavedRecipes() async {
    emit(state.copyWith(status: SavedRecipesStatus.loading));
    final response = await _getSavedRecipesUseCase(const NoParams());
    response.fold(
      (message) => emit(
        state.copyWith(
          status: SavedRecipesStatus.failure,
          errorMessage: message,
        ),
      ),
      (recipes) => emit(
        state.copyWith(
          status: SavedRecipesStatus.success,
          recipes: recipes,
          savedRecipeIds: recipes.map((recipe) => recipe.id).toSet(),
        ),
      ),
    );
  }

  Future<void> loadSavedRecipeIds() async {
    final response = await _getSavedRecipeIdsUseCase(const NoParams());
    response.fold(
      (message) => emit(
        state.copyWith(
          status: SavedRecipesStatus.failure,
          errorMessage: message,
        ),
      ),
      (ids) => emit(
        state.copyWith(
          status: state.status == SavedRecipesStatus.initial
              ? SavedRecipesStatus.success
              : state.status,
          savedRecipeIds: ids,
        ),
      ),
    );
  }

  Future<void> toggleRecipe(HomeRecipe recipe) async {
    if (state.savedRecipeIds.contains(recipe.id)) {
      await unsaveRecipe(recipe.id);
      return;
    }
    await saveRecipe(recipe);
  }

  Future<void> saveRecipe(HomeRecipe recipe) async {
    emit(state.copyWith(status: SavedRecipesStatus.updating));
    final response = await _saveRecipeUseCase(SaveRecipeParams(recipe.id));
    response.fold(
      (message) => emit(
        state.copyWith(
          status: SavedRecipesStatus.failure,
          errorMessage: message,
        ),
      ),
      (_) {
        final recipes = state.recipes.any((item) => item.id == recipe.id)
            ? state.recipes
            : [recipe, ...state.recipes];
        emit(
          state.copyWith(
            status: SavedRecipesStatus.success,
            recipes: recipes,
            savedRecipeIds: {...state.savedRecipeIds, recipe.id},
          ),
        );
      },
    );
  }

  Future<void> unsaveRecipe(String recipeId) async {
    emit(state.copyWith(status: SavedRecipesStatus.updating));
    final response = await _unsaveRecipeUseCase(UnsaveRecipeParams(recipeId));
    response.fold(
      (message) => emit(
        state.copyWith(
          status: SavedRecipesStatus.failure,
          errorMessage: message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: SavedRecipesStatus.success,
          recipes: state.recipes
              .where((recipe) => recipe.id != recipeId)
              .toList(),
          savedRecipeIds: {...state.savedRecipeIds}..remove(recipeId),
        ),
      ),
    );
  }

  void clear() {
    emit(const SavedRecipesState());
  }
}
