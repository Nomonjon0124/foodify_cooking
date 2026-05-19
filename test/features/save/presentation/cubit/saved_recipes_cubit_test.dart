import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/home/domain/entities/home_feed.dart';
import 'package:foodify_cooking/features/save/domain/repositories/saved_recipes_repository.dart';
import 'package:foodify_cooking/features/save/domain/usecases/get_saved_recipe_ids_usecase.dart';
import 'package:foodify_cooking/features/save/domain/usecases/get_saved_recipes_usecase.dart';
import 'package:foodify_cooking/features/save/domain/usecases/save_recipe_usecase.dart';
import 'package:foodify_cooking/features/save/domain/usecases/unsave_recipe_usecase.dart';
import 'package:foodify_cooking/features/save/presentation/cubit/saved_recipes_cubit.dart';
import 'package:foodify_cooking/features/save/presentation/cubit/saved_recipes_state.dart';

void main() {
  group('SavedRecipesCubit', () {
    late _FakeSavedRecipesRepository repository;
    late SavedRecipesCubit cubit;

    setUp(() {
      repository = _FakeSavedRecipesRepository();
      cubit = SavedRecipesCubit(
        getSavedRecipesUseCase: GetSavedRecipesUseCase(repository),
        getSavedRecipeIdsUseCase: GetSavedRecipeIdsUseCase(repository),
        saveRecipeUseCase: SaveRecipeUseCase(repository),
        unsaveRecipeUseCase: UnsaveRecipeUseCase(repository),
      );
    });

    tearDown(() => cubit.close());

    test('loads saved ids for home card state', () async {
      repository.savedIds.add('recipe-1');

      await cubit.loadSavedRecipeIds();

      expect(cubit.state.status, SavedRecipesStatus.success);
      expect(cubit.state.savedRecipeIds, {'recipe-1'});
    });

    test('saves and unsaves a recipe', () async {
      await cubit.saveRecipe(_FakeSavedRecipesRepository.recipe);

      expect(cubit.state.isSaved('recipe-1'), isTrue);
      expect(cubit.state.recipes.single.title, 'Saved cake');

      await cubit.unsaveRecipe('recipe-1');

      expect(cubit.state.isSaved('recipe-1'), isFalse);
      expect(cubit.state.recipes, isEmpty);
    });
  });
}

class _FakeSavedRecipesRepository implements SavedRecipesRepository {
  static const recipe = HomeRecipe(
    id: 'recipe-1',
    title: 'Saved cake',
    coverImageUrl: 'https://example.com/cake.png',
    topRatingLabel: '4.8',
  );

  final savedIds = <String>{};
  final savedRecipes = <HomeRecipe>[];

  @override
  Future<Result<Set<String>>> getSavedRecipeIds() async {
    return Success<Set<String>>(savedIds);
  }

  @override
  Future<Result<List<HomeRecipe>>> getSavedRecipes() async {
    return Success<List<HomeRecipe>>(savedRecipes);
  }

  @override
  Future<Result<void>> saveRecipe(String recipeId) async {
    savedIds.add(recipeId);
    if (!savedRecipes.any((recipe) => recipe.id == recipeId)) {
      savedRecipes.add(recipe);
    }
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> unsaveRecipe(String recipeId) async {
    savedIds.remove(recipeId);
    savedRecipes.removeWhere((recipe) => recipe.id == recipeId);
    return const Success<void>(null);
  }
}
