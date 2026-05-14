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
        .eq('is_active', true)
        .order('sort_order');

    return HomeFeedModel.fromFeedItems(response);
  }
}
