import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_view_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileViewModel> getProfileBySlug(String slug);
  Future<ProfileViewModel> getCurrentProfile();
}

class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  SupabaseProfileRemoteDataSource(this._readClient);

  final SupabaseClient Function() _readClient;

  static const _defaultProfileSlug = 'mark-salvador';

  static const _profileViewColumns = '''
    id,
    slug,
    display_name,
    first_name,
    last_name,
    location,
    bio,
    avatar_url,
    cover_image_url,
    rating,
    followers_count,
    following_count,
    posts_count,
    is_current_user
  ''';

  static const _profileTableColumns = '''
    id,
    slug,
    display_name,
    first_name,
    last_name,
    location,
    bio,
    avatar_url,
    cover_image_url,
    rating,
    followers_count,
    following_count,
    posts_count
  ''';

  static const _recipeViewColumns = '''
    id,
    author_id,
    title,
    description,
    rating,
    duration_minutes,
    difficulty,
    cover_image_url,
    chef_name,
    chef_avatar_url
  ''';

  @override
  Future<ProfileViewModel> getProfileBySlug(String slug) async {
    final client = _readClient();
    final profileJson = await _fetchProfileBySlug(client, slug);
    final recipes = await _fetchRecipesForProfile(
      client,
      _stringValue(profileJson['id']),
    );

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

    final defaultProfile = await _fetchDefaultProfile(client);
    final currentProfile =
        await _fetchCurrentProfile(client) ??
        await _createProfileForCurrentUser(
          client,
          user,
          defaultProfile: defaultProfile,
        );
    final profileJson = await _ensureDefaultVisualFields(
      client,
      currentProfile,
      defaultProfile,
    );

    var recipes = await _fetchRecipesForProfile(
      client,
      _stringValue(profileJson['id']),
    );
    final usesFallbackRecipes = recipes.isEmpty && defaultProfile != null;
    if (usesFallbackRecipes) {
      recipes = await _fetchRecipesForProfile(
        client,
        _stringValue(defaultProfile['id']),
      );
    }

    return ProfileViewModel.fromJson(
      profileJson: profileJson,
      recipesJson: recipes,
      useRecipesCountWhenPostsEmpty: usesFallbackRecipes,
    );
  }

  Future<Map<String, dynamic>?> _fetchCurrentProfile(
    SupabaseClient client,
  ) async {
    final profiles = await client
        .from('profile_page_view')
        .select(_profileViewColumns)
        .eq('is_current_user', true)
        .limit(1);

    if (profiles.isEmpty) return null;
    return _mapValue(profiles.first);
  }

  Future<Map<String, dynamic>> _fetchProfileBySlug(
    SupabaseClient client,
    String slug,
  ) async {
    final profiles = await client
        .from('profile_page_view')
        .select(_profileViewColumns)
        .eq('slug', slug)
        .limit(1);

    if (profiles.isEmpty) {
      throw StateError('Profile not found');
    }

    return _mapValue(profiles.first);
  }

  Future<Map<String, dynamic>?> _fetchDefaultProfile(
    SupabaseClient client,
  ) async {
    try {
      return await _fetchProfileBySlug(client, _defaultProfileSlug);
    } catch (_) {
      return null;
    }
  }

  Future<List<dynamic>> _fetchRecipesForProfile(
    SupabaseClient client,
    String profileId,
  ) async {
    if (profileId.isEmpty) return const [];

    final recipes = await client
        .from('profile_recipes_view')
        .select(_recipeViewColumns)
        .eq('author_id', profileId)
        .order('search_sort_order', nullsFirst: false);

    return List<dynamic>.from(recipes);
  }

  Future<Map<String, dynamic>> _createProfileForCurrentUser(
    SupabaseClient client,
    User user, {
    required Map<String, dynamic>? defaultProfile,
  }) async {
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
    final nameParts = _splitDisplayName(displayName);
    final defaultAvatarUrl = _stringValue(defaultProfile?['avatar_url']);

    final created = await client
        .from('profiles')
        .insert({
          'auth_user_id': user.id,
          'first_name': nameParts.$1,
          'last_name': nameParts.$2,
          'display_name': displayName.isEmpty ? 'Foodify User' : displayName,
          'location': _nullableString(defaultProfile?['location']),
          'bio': _nullableString(defaultProfile?['bio']),
          'avatar_url': avatarUrl.isEmpty ? defaultAvatarUrl : avatarUrl,
          'cover_image_url': _nullableString(
            defaultProfile?['cover_image_url'],
          ),
        })
        .select(_profileTableColumns)
        .single();

    return _mapValue(created);
  }

  Future<Map<String, dynamic>> _ensureDefaultVisualFields(
    SupabaseClient client,
    Map<String, dynamic> profileJson,
    Map<String, dynamic>? defaultProfile,
  ) async {
    if (defaultProfile == null) return profileJson;

    final patch = <String, dynamic>{};
    for (final field in ['location', 'bio', 'avatar_url', 'cover_image_url']) {
      if (_isBlank(profileJson[field]) && !_isBlank(defaultProfile[field])) {
        patch[field] = defaultProfile[field];
      }
    }

    if (patch.isEmpty) return profileJson;

    final updated = await client
        .from('profiles')
        .update(patch)
        .eq('id', _stringValue(profileJson['id']))
        .select(_profileTableColumns)
        .single();

    return _mapValue(updated);
  }
}

(String, String?) _splitDisplayName(String displayName) {
  final trimmed = displayName.trim();
  if (trimmed.isEmpty) return ('Foodify', 'User');

  final parts = trimmed.split(RegExp(r'\s+'));
  if (parts.length == 1) return (parts.first, null);

  return (parts.first, parts.skip(1).join(' '));
}

Map<String, dynamic> _mapValue(Object? value) {
  return Map<String, dynamic>.from(value as Map);
}

String _stringValue(Object? value) => value?.toString() ?? '';

String? _nullableString(Object? value) {
  final string = _stringValue(value).trim();
  return string.isEmpty ? null : string;
}

bool _isBlank(Object? value) => _stringValue(value).trim().isEmpty;
