import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_popular_recipes_usecase.dart';
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit(this._getPopularRecipesUseCase) : super(const RecipeState());

  final GetPopularRecipesUseCase _getPopularRecipesUseCase;

  Future<void> loadRecipes() async {
    emit(state.copyWith(status: RecipeStatus.loading));
    try {
      final recipes = await _getPopularRecipesUseCase(const NoParams());
      emit(state.copyWith(status: RecipeStatus.success, recipes: recipes));
    } catch (_) {
      emit(
        state.copyWith(
          status: RecipeStatus.failure,
          errorMessage: 'Failed to load recipes',
        ),
      );
    }
  }
}
