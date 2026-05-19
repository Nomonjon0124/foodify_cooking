import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../home/data/models/home_feed_model.dart';
import '../../../home/domain/entities/home_feed.dart';

abstract interface class SavedRecipesRemoteDataSource {
  Future<List<HomeRecipe>> getSavedRecipes();
  Future<Set<String>> getSavedRecipeIds();
  Future<void> saveRecipe(String recipeId);
  Future<void> unsaveRecipe(String recipeId);
}

class SupabaseSavedRecipesRemoteDataSource
    implements SavedRecipesRemoteDataSource {
  SupabaseSavedRecipesRemoteDataSource(this._readClient);

  final SupabaseClient Function() _readClient;

  @override
  Future<List<HomeRecipe>> getSavedRecipes() async {
    final userId = _currentUserId();
    final response = await _readClient()
        .from('user_saved_recipes')
        .select('''
          recipe:recipes (
            id,
            title,
            description,
            rating,
            duration_minutes,
            difficulty,
            cover_image_url,
            overlay_image_url,
            author:profiles (
              id,
              display_name,
              avatar_url,
              rating
            )
          ),
          created_at
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response
        .whereType<Map<String, dynamic>>()
        .map((row) => row['recipe'])
        .whereType<Map<String, dynamic>>()
        .map(HomeRecipeModel.fromJson)
        .toList();
  }

  @override
  Future<Set<String>> getSavedRecipeIds() async {
    final userId = _currentUserId();
    final response = await _readClient()
        .from('user_saved_recipes')
        .select('recipe_id')
        .eq('user_id', userId);

    return response
        .whereType<Map<String, dynamic>>()
        .map((row) => row['recipe_id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  @override
  Future<void> saveRecipe(String recipeId) async {
    final userId = _currentUserId();
    await _readClient().from('user_saved_recipes').upsert({
      'user_id': userId,
      'recipe_id': recipeId,
    });
  }

  @override
  Future<void> unsaveRecipe(String recipeId) async {
    final userId = _currentUserId();
    await _readClient()
        .from('user_saved_recipes')
        .delete()
        .eq('user_id', userId)
        .eq('recipe_id', recipeId);
  }

  String _currentUserId() {
    final userId = _readClient().auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw AuthException('Login required');
    }
    return userId;
  }
}
