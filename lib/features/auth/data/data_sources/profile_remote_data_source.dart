import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_view_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileViewModel> getProfileBySlug(String slug);
  Future<ProfileViewModel> getCurrentProfile();
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

  @override
  Future<ProfileViewModel> getCurrentProfile() async {
    final client = _readClient();
    final user = client.auth.currentUser;
    if (user == null) {
      throw AuthException('Login required');
    }

    final profiles = await client
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
        .eq('auth_user_id', user.id)
        .limit(1);

    final profileJson = profiles.isEmpty
        ? await _createProfileForCurrentUser(client, user)
        : profiles.first;
    final profileId = profileJson['id']?.toString() ?? '';

    final recipes = await client
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

  Future<Map<String, dynamic>> _createProfileForCurrentUser(
    SupabaseClient client,
    User user,
  ) async {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final email = user.email ?? '';
    final fallbackName = email.contains('@') ? email.split('@').first : email;
    final displayName =
        (metadata['full_name'] ??
                metadata['name'] ??
                metadata['display_name'] ??
                fallbackName)
            .toString()
            .trim();
    final avatarUrl = (metadata['avatar_url'] ?? metadata['picture'] ?? '')
        .toString();

    final created = await client
        .from('profiles')
        .insert({
          'auth_user_id': user.id,
          'display_name': displayName.isEmpty ? 'Foodify User' : displayName,
          'avatar_url': avatarUrl,
        })
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
        .single();

    return created;
  }
}
