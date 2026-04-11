import '../../domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  @override
  Future<List<String>> getPopularRecipes() async {
    // TODO: Replace static content with paginated API integration.
    return const <String>['Chicken Alfredo', 'Veggie Pasta', 'Classic Burger'];
  }
}
