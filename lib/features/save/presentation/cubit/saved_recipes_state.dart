import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/home_feed.dart';

enum SavedRecipesStatus { initial, loading, success, updating, failure }

class SavedRecipesState extends Equatable {
  const SavedRecipesState({
    this.status = SavedRecipesStatus.initial,
    this.recipes = const <HomeRecipe>[],
    this.savedRecipeIds = const <String>{},
    this.errorMessage,
  });

  final SavedRecipesStatus status;
  final List<HomeRecipe> recipes;
  final Set<String> savedRecipeIds;
  final String? errorMessage;

  bool isSaved(String recipeId) => savedRecipeIds.contains(recipeId);

  SavedRecipesState copyWith({
    SavedRecipesStatus? status,
    List<HomeRecipe>? recipes,
    Set<String>? savedRecipeIds,
    String? errorMessage,
  }) {
    return SavedRecipesState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      savedRecipeIds: savedRecipeIds ?? this.savedRecipeIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recipes, savedRecipeIds, errorMessage];
}
