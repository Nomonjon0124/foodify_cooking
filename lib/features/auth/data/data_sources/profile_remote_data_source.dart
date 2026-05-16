import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_view_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileViewModel> getProfileBySlug(String slug);
}

class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  SupabaseProfileRemoteDataSource(this._readClient);

  final SupabaseClient Function() _readClient;

  @override
  Future<ProfileViewModel> getProfileBySlug(String slug) async {
    final profiles = await _readClient()
        .from('profiles')
        .select('''
          id,
          display_name,
          location,
          bio,
          avatar_url,
          cover_image_url,
          rating,
          followers_count,
          following_count,
          posts_count
        ''')
        .eq('slug', slug)
        .limit(1);

    if (profiles.isEmpty) {
      throw StateError('Profile not found');
    }

    final profileJson = profiles.first;
    final profileId = profileJson['id']?.toString() ?? '';

    final recipes = await _readClient()
        .from('recipes')
        .select('''
          id,
          title,
          description,
          rating,
          duration_minutes,
          difficulty,
          cover_image_url
        ''')
        .eq('author_id', profileId)
        .eq('is_profile_visible', true)
        .order('search_sort_order', nullsFirst: false);

    return ProfileViewModel.fromJson(
      profileJson: profileJson,
      recipesJson: recipes,
    );
  }
}
