import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/home/domain/entities/home_feed.dart';
import 'package:foodify_cooking/features/recipe/domain/entities/recipe_detail.dart';
import 'package:foodify_cooking/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:foodify_cooking/features/recipe/domain/usecases/get_recipe_detail_usecase.dart';
import 'package:foodify_cooking/features/recipe/domain/usecases/toggle_recipe_like_usecase.dart';
import 'package:foodify_cooking/features/recipe/presentation/cubit/recipe_detail_cubit.dart';
import 'package:foodify_cooking/features/recipe/presentation/cubit/recipe_detail_state.dart';
import 'package:foodify_cooking/features/save/domain/repositories/saved_recipes_repository.dart';
import 'package:foodify_cooking/features/save/domain/usecases/get_saved_recipe_ids_usecase.dart';
import 'package:foodify_cooking/features/save/domain/usecases/get_saved_recipes_usecase.dart';
import 'package:foodify_cooking/features/save/domain/usecases/save_recipe_usecase.dart';
import 'package:foodify_cooking/features/save/domain/usecases/unsave_recipe_usecase.dart';
import 'package:foodify_cooking/features/save/presentation/cubit/saved_recipes_cubit.dart';

void main() {
  group('RecipeDetailCubit', () {
    late _FakeRecipeRepository repo;
    late _FakeSavedRepository savedRepo;
    late SavedRecipesCubit savedCubit;
    late RecipeDetailCubit cubit;

    setUp(() {
      repo = _FakeRecipeRepository();
      savedRepo = _FakeSavedRepository();
      savedCubit = SavedRecipesCubit(
        getSavedRecipesUseCase: GetSavedRecipesUseCase(savedRepo),
        getSavedRecipeIdsUseCase: GetSavedRecipeIdsUseCase(savedRepo),
        saveRecipeUseCase: SaveRecipeUseCase(savedRepo),
        unsaveRecipeUseCase: UnsaveRecipeUseCase(savedRepo),
      );
      cubit = RecipeDetailCubit(
        getRecipeDetailUseCase: GetRecipeDetailUseCase(repo),
        toggleRecipeLikeUseCase: ToggleRecipeLikeUseCase(repo),
        savedRecipesCubit: savedCubit,
      );
    });

    tearDown(() async {
      await cubit.close();
      await savedCubit.close();
    });

    test('load success emits recipe with saved sync', () async {
      savedRepo.savedIds.add('r-1');
      await savedCubit.loadSavedRecipeIds();
      repo.detail = _detail(id: 'r-1', likesCount: 5);

      await cubit.load('r-1');

      expect(cubit.state.status, RecipeDetailStatus.success);
      expect(cubit.state.recipe?.isSavedByMe, isTrue);
      expect(cubit.state.recipe?.likesCount, 5);
    });

    test('load failure surfaces error', () async {
      repo.failureMessage = 'Boom';

      await cubit.load('r-1');

      expect(cubit.state.status, RecipeDetailStatus.failure);
      expect(cubit.state.errorMessage, 'Boom');
    });

    test('changeTab updates active tab and ignores duplicate', () async {
      cubit.changeTab(RecipeDetailTab.ingredients);
      expect(cubit.state.activeTab, RecipeDetailTab.ingredients);
      cubit.changeTab(RecipeDetailTab.ingredients);
      expect(cubit.state.activeTab, RecipeDetailTab.ingredients);
    });

    test('available tabs do not include comments', () {
      expect(RecipeDetailTab.values, [
        RecipeDetailTab.introduction,
        RecipeDetailTab.ingredients,
        RecipeDetailTab.aiAnalysis,
      ]);
    });

    test('toggleLike applies optimistic state then confirmed result', () async {
      repo.detail = _detail(id: 'r-1', likesCount: 4);
      await cubit.load('r-1');

      repo.toggleResult = const RecipeLikeToggle(isLiked: true, likesCount: 5);
      await cubit.toggleLike();

      expect(cubit.state.recipe?.isLikedByMe, isTrue);
      expect(cubit.state.recipe?.likesCount, 5);
      expect(cubit.state.isLikeInFlight, isFalse);
    });

    test('toggleLike reverts on failure', () async {
      repo.detail = _detail(id: 'r-1', likesCount: 4);
      await cubit.load('r-1');

      repo.toggleFailureMessage = 'No network';
      await cubit.toggleLike();

      expect(cubit.state.recipe?.isLikedByMe, isFalse);
      expect(cubit.state.recipe?.likesCount, 4);
      expect(cubit.state.errorMessage, 'No network');
    });
  });
}

RecipeDetail _detail({required String id, required int likesCount}) {
  return RecipeDetail(
    id: id,
    title: 'Pancake',
    coverImageUrl: 'https://example.com/p.png',
    ratingLabel: '4.5',
    likesCount: likesCount,
    commentsCount: 0,
    isLikedByMe: false,
    isSavedByMe: false,
    tags: const [],
    ingredients: const [],
    instructions: const [],
    comments: const [],
  );
}

class _FakeRecipeRepository implements RecipeRepository {
  RecipeDetail? detail;
  String? failureMessage;
  RecipeLikeToggle? toggleResult;
  String? toggleFailureMessage;

  @override
  Future<Result<RecipeDetail>> getRecipeDetail(String recipeId) async {
    final msg = failureMessage;
    if (msg != null) return Failure<RecipeDetail>(msg);
    return Success<RecipeDetail>(detail!);
  }

  @override
  Future<Result<RecipeLikeToggle>> toggleLike(String recipeId) async {
    final msg = toggleFailureMessage;
    if (msg != null) return Failure<RecipeLikeToggle>(msg);
    return Success<RecipeLikeToggle>(toggleResult!);
  }
}

class _FakeSavedRepository implements SavedRecipesRepository {
  final savedIds = <String>{};
  final savedRecipes = <HomeRecipe>[];

  @override
  Future<Result<List<HomeRecipe>>> getSavedRecipes() async =>
      Success<List<HomeRecipe>>(savedRecipes);

  @override
  Future<Result<Set<String>>> getSavedRecipeIds() async =>
      Success<Set<String>>(Set<String>.from(savedIds));

  @override
  Future<Result<void>> saveRecipe(String recipeId) async {
    savedIds.add(recipeId);
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> unsaveRecipe(String recipeId) async {
    savedIds.remove(recipeId);
    return const Success<void>(null);
  }
}
