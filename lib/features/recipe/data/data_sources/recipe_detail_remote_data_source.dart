import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/recipe_detail_model.dart';

abstract interface class RecipeDetailRemoteDataSource {
  Future<RecipeDetailModel> getRecipeDetail(String recipeId);

  /// Returns the new total likes count and whether the recipe is now liked
  /// by the current user.
  Future<RecipeLikeToggleResult> toggleLike(String recipeId);
}

class RecipeLikeToggleResult {
  const RecipeLikeToggleResult({
    required this.isLiked,
    required this.likesCount,
  });

  final bool isLiked;
  final int likesCount;
}

class SupabaseRecipeDetailRemoteDataSource
    implements RecipeDetailRemoteDataSource {
  SupabaseRecipeDetailRemoteDataSource(this._readClient);

  final SupabaseClient Function() _readClient;

  static const _recipeSelect = '''
    id,
    title,
    description,
    rating,
    duration_minutes,
    difficulty,
    cover_image_url,
    overlay_image_url,
    author:profiles!recipes_author_id_fkey (
      id,
      display_name,
      avatar_url,
      rating
    ),
    recipe_ingredients (
      id,
      position,
      content
    ),
    recipe_instructions (
      id,
      step_number,
      content
    ),
    recipe_tags (
      tags (
        slug,
        display_name
      )
    )
  ''';

  @override
  Future<RecipeDetailModel> getRecipeDetail(String recipeId) async {
    final client = _readClient();
    final currentUserId = client.auth.currentUser?.id;

    final recipeJson = await client
        .from('recipes')
        .select(_recipeSelect)
        .eq('id', recipeId)
        .single();

    final likesCountResponse = await client
        .from('recipe_likes')
        .select('user_id')
        .eq('recipe_id', recipeId)
        .count(CountOption.exact);

    var isLiked = false;
    var isSaved = false;
    if (currentUserId != null) {
      final likeRow = await client
          .from('recipe_likes')
          .select('user_id')
          .eq('recipe_id', recipeId)
          .eq('user_id', currentUserId)
          .maybeSingle();
      isLiked = likeRow != null;

      final savedRow = await client
          .from('user_saved_recipes')
          .select('recipe_id')
          .eq('recipe_id', recipeId)
          .eq('user_id', currentUserId)
          .maybeSingle();
      isSaved = savedRow != null;
    }

    return RecipeDetailModel.fromJson(
      recipeJson,
      likesCount: likesCountResponse.count,
      isLikedByMe: isLiked,
      isSavedByMe: isSaved,
    );
  }

  @override
  Future<RecipeLikeToggleResult> toggleLike(String recipeId) async {
    final client = _readClient();
    final userId = _requireUserId(client);

    final existing = await client
        .from('recipe_likes')
        .select('user_id')
        .eq('user_id', userId)
        .eq('recipe_id', recipeId)
        .maybeSingle();

    if (existing == null) {
      await client.from('recipe_likes').insert({
        'user_id': userId,
        'recipe_id': recipeId,
      });
    } else {
      await client
          .from('recipe_likes')
          .delete()
          .eq('user_id', userId)
          .eq('recipe_id', recipeId);
    }

    final countResponse = await client
        .from('recipe_likes')
        .select('user_id')
        .eq('recipe_id', recipeId)
        .count(CountOption.exact);

    return RecipeLikeToggleResult(
      isLiked: existing == null,
      likesCount: countResponse.count,
    );
  }

  String _requireUserId(SupabaseClient client) {
    final userId = client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw AuthException('Login required');
    }
    return userId;
  }
}
