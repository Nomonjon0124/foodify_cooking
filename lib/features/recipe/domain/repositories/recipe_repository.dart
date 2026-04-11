abstract interface class RecipeRepository {
  Future<List<String>> getPopularRecipes();
}
