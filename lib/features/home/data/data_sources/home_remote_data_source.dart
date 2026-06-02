import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/home_feed_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<HomeFeedModel> getHomeFeed();
}

class SupabaseHomeRemoteDataSource implements HomeRemoteDataSource {
  SupabaseHomeRemoteDataSource(this._readClient);

  final SupabaseClient Function() _readClient;

  @override
  Future<HomeFeedModel> getHomeFeed() async {
    final results = await Future.wait<List<dynamic>>([
      _fetchPopularRecipes(),
      _fetchLatestRecipes(),
    ]);

    return HomeFeedModel(
      popularRecipes: HomeFeedModel.fromFeedItems(results[0]).popularRecipes,
      latestRecipes: results[1]
          .whereType<Map<String, dynamic>>()
          .map(HomeRecipeModel.fromJson)
          .toList(),
    );
  }

  Future<List<dynamic>> _fetchPopularRecipes() async {
    final response = await _readClient()
        .from('home_feed_items')
        .select('''
          section,
          sort_order,
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
          )
        ''')
        .eq('section', 'popular')
        .eq('is_active', true)
        .order('sort_order');

    return List<dynamic>.from(response);
  }

  Future<List<dynamic>> _fetchLatestRecipes() async {
    final response = await _readClient()
        .from('recipes')
        .select('''
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
        ''')
        .eq('is_profile_visible', true)
        .order('created_at', ascending: false)
        .limit(10);

    return List<dynamic>.from(response);
  }
}
