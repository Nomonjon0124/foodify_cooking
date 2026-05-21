import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/home_feed.dart';
import '../../../save/presentation/cubit/saved_recipes_cubit.dart';
import '../../../save/presentation/cubit/saved_recipes_state.dart';
import '../../domain/usecases/get_recipe_detail_usecase.dart';
import '../../domain/usecases/toggle_recipe_like_usecase.dart';
import 'recipe_detail_state.dart';

class RecipeDetailCubit extends Cubit<RecipeDetailState> {
  RecipeDetailCubit({
    required GetRecipeDetailUseCase getRecipeDetailUseCase,
    required ToggleRecipeLikeUseCase toggleRecipeLikeUseCase,
    required SavedRecipesCubit savedRecipesCubit,
  }) : _getRecipeDetailUseCase = getRecipeDetailUseCase,
       _toggleRecipeLikeUseCase = toggleRecipeLikeUseCase,
       _savedRecipesCubit = savedRecipesCubit,
       super(const RecipeDetailState()) {
    _savedSubscription = _savedRecipesCubit.stream.listen(_onSavedStateChanged);
  }

  final GetRecipeDetailUseCase _getRecipeDetailUseCase;
  final ToggleRecipeLikeUseCase _toggleRecipeLikeUseCase;
  final SavedRecipesCubit _savedRecipesCubit;
  late final StreamSubscription<SavedRecipesState> _savedSubscription;

  Future<void> load(String recipeId) async {
    emit(state.copyWith(status: RecipeDetailStatus.loading, clearError: true));

    final response = await _getRecipeDetailUseCase(
      GetRecipeDetailParams(recipeId),
    );
    response.fold(
      (message) => emit(
        state.copyWith(
          status: RecipeDetailStatus.failure,
          errorMessage: message,
        ),
      ),
      (recipe) {
        final synced = recipe.copyWith(
          isSavedByMe: _savedRecipesCubit.state.isSaved(recipe.id),
        );
        emit(
          state.copyWith(status: RecipeDetailStatus.success, recipe: synced),
        );
      },
    );
  }

  void changeTab(RecipeDetailTab tab) {
    if (state.activeTab == tab) return;
    emit(state.copyWith(activeTab: tab));
  }

  Future<void> toggleLike() async {
    final recipe = state.recipe;
    if (recipe == null || state.isLikeInFlight) return;

    final previousIsLiked = recipe.isLikedByMe;
    final previousCount = recipe.likesCount;
    final optimisticCount = previousIsLiked
        ? (previousCount - 1).clamp(0, previousCount)
        : previousCount + 1;

    emit(
      state.copyWith(
        isLikeInFlight: true,
        recipe: recipe.copyWith(
          isLikedByMe: !previousIsLiked,
          likesCount: optimisticCount,
        ),
      ),
    );

    final response = await _toggleRecipeLikeUseCase(
      ToggleRecipeLikeParams(recipe.id),
    );
    response.fold(
      (message) {
        emit(
          state.copyWith(
            isLikeInFlight: false,
            recipe: state.recipe?.copyWith(
              isLikedByMe: previousIsLiked,
              likesCount: previousCount,
            ),
            errorMessage: message,
          ),
        );
      },
      (result) {
        emit(
          state.copyWith(
            isLikeInFlight: false,
            recipe: state.recipe?.copyWith(
              isLikedByMe: result.isLiked,
              likesCount: result.likesCount,
            ),
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> toggleSave() async {
    final recipe = state.recipe;
    if (recipe == null) return;
    final homeRecipe = HomeRecipe(
      id: recipe.id,
      title: recipe.title,
      coverImageUrl: recipe.coverImageUrl,
      topRatingLabel: recipe.ratingLabel,
      description: recipe.description,
      durationLabel: recipe.durationLabel,
      difficultyLabel: recipe.difficultyLabel,
      overlayImageUrl: recipe.overlayImageUrl,
    );
    await _savedRecipesCubit.toggleRecipe(homeRecipe);
  }

  void _onSavedStateChanged(SavedRecipesState saved) {
    final recipe = state.recipe;
    if (recipe == null) return;
    final isSavedNow = saved.isSaved(recipe.id);
    if (isSavedNow == recipe.isSavedByMe) return;
    emit(state.copyWith(recipe: recipe.copyWith(isSavedByMe: isSavedNow)));
  }

  @override
  Future<void> close() {
    _savedSubscription.cancel();
    return super.close();
  }
}
