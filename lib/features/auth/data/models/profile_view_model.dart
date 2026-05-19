import '../../domain/entities/profile_view.dart';

class ProfileViewModel extends ProfileView {
  const ProfileViewModel({
    required super.id,
    required super.displayName,
    required super.location,
    required super.bio,
    required super.avatarUrl,
    required super.coverImageUrl,
    required super.ratingLabel,
    required super.followersLabel,
    required super.followingLabel,
    required super.postsCount,
    required super.recipes,
  });

  factory ProfileViewModel.fromJson({
    required Map<String, dynamic> profileJson,
    required List<dynamic> recipesJson,
    bool useRecipesCountWhenPostsEmpty = false,
  }) {
    final displayName = _stringValue(profileJson['display_name']);
    final avatarUrl = _stringValue(profileJson['avatar_url']);
    final recipes = recipesJson
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => ProfileRecipeModel.fromJson(
            json,
            fallbackChefName: displayName,
            fallbackChefAvatarUrl: avatarUrl,
          ),
        )
        .toList();
    final postsCount = _intValue(profileJson['posts_count']);

    return ProfileViewModel(
      id: _stringValue(profileJson['id']),
      displayName: displayName,
      location: _stringValue(profileJson['location']),
      bio: _stringValue(profileJson['bio']),
      avatarUrl: avatarUrl,
      coverImageUrl: _stringValue(profileJson['cover_image_url']),
      ratingLabel: _ratingLabel(profileJson['rating']),
      followersLabel: _compactCount(profileJson['followers_count']),
      followingLabel: _compactCount(profileJson['following_count']),
      postsCount:
          useRecipesCountWhenPostsEmpty && postsCount == 0 && recipes.isNotEmpty
          ? recipes.length
          : postsCount,
      recipes: recipes,
    );
  }
}

class ProfileRecipeModel extends ProfileRecipe {
  const ProfileRecipeModel({
    required super.id,
    required super.title,
    required super.chefName,
    required super.ratingLabel,
    required super.durationLabel,
    required super.difficultyLabel,
    required super.description,
    required super.imageUrl,
    required super.chefAvatarUrl,
  });

  factory ProfileRecipeModel.fromJson(
    Map<String, dynamic> json, {
    required String fallbackChefName,
    required String fallbackChefAvatarUrl,
  }) {
    return ProfileRecipeModel(
      id: _stringValue(json['id']),
      title: _stringValue(json['title']),
      chefName: _stringValue(json['chef_name']).isEmpty
          ? fallbackChefName
          : _stringValue(json['chef_name']),
      ratingLabel: _ratingLabel(json['rating']),
      durationLabel: _durationLabel(json['duration_minutes']),
      difficultyLabel: _stringValue(json['difficulty']),
      description: _stringValue(json['description']),
      imageUrl: _stringValue(json['cover_image_url']),
      chefAvatarUrl: _stringValue(json['chef_avatar_url']).isEmpty
          ? fallbackChefAvatarUrl
          : _stringValue(json['chef_avatar_url']),
    );
  }
}

String _stringValue(Object? value) => value?.toString() ?? '';

int _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _ratingLabel(Object? value) {
  final rating = switch (value) {
    num() => value,
    String() => num.tryParse(value),
    _ => null,
  };

  return rating == null ? '0.0' : rating.toStringAsFixed(1);
}

String _durationLabel(Object? value) {
  final minutes = _intValue(value);
  return minutes <= 0 ? '' : '$minutes Min';
}

String _compactCount(Object? value) {
  final count = _intValue(value);
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
  if (count >= 1000) {
    final formatted = count % 1000 == 0
        ? (count ~/ 1000).toString()
        : (count / 1000).toStringAsFixed(1);
    return '${formatted}K';
  }
  return count.toString();
}
