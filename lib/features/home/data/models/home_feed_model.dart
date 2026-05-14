import '../../domain/entities/home_feed.dart';

class HomeFeedModel extends HomeFeed {
  const HomeFeedModel({
    required super.popularRecipes,
    required super.latestRecipes,
  });

  factory HomeFeedModel.fromFeedItems(List<dynamic> rows) {
    final popularRecipes = <HomeRecipe>[];
    final latestRecipes = <HomeRecipe>[];

    for (final row in rows) {
      if (row is! Map<String, dynamic>) continue;

      final recipeJson = row['recipe'];
      if (recipeJson is! Map<String, dynamic>) continue;

      final recipe = HomeRecipeModel.fromJson(recipeJson);
      switch (row['section']) {
        case 'popular':
          popularRecipes.add(recipe);
        case 'latest':
          latestRecipes.add(recipe);
      }
    }

    return HomeFeedModel(
      popularRecipes: popularRecipes,
      latestRecipes: latestRecipes,
    );
  }
}

class HomeRecipeModel extends HomeRecipe {
  const HomeRecipeModel({
    required super.id,
    required super.title,
    required super.coverImageUrl,
    required super.topRatingLabel,
    super.description,
    super.durationLabel,
    super.difficultyLabel,
    super.overlayImageUrl,
    super.author,
  });

  factory HomeRecipeModel.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'];

    return HomeRecipeModel(
      id: _stringValue(json['id']),
      title: _stringValue(json['title']),
      description: _nullableStringValue(json['description']),
      durationLabel: _durationLabel(json['duration_minutes']),
      difficultyLabel: _nullableStringValue(json['difficulty']),
      coverImageUrl: _stringValue(json['cover_image_url']),
      overlayImageUrl: _nullableStringValue(json['overlay_image_url']),
      topRatingLabel: _ratingLabel(json['rating']),
      author: authorJson is Map<String, dynamic>
          ? HomeProfileModel.fromJson(authorJson)
          : null,
    );
  }
}

class HomeProfileModel extends HomeProfile {
  const HomeProfileModel({
    required super.id,
    required super.displayName,
    super.avatarUrl,
    super.ratingLabel,
  });

  factory HomeProfileModel.fromJson(Map<String, dynamic> json) {
    return HomeProfileModel(
      id: _stringValue(json['id']),
      displayName: _stringValue(json['display_name']),
      avatarUrl: _nullableStringValue(json['avatar_url']),
      ratingLabel: _ratingLabel(json['rating']),
    );
  }
}

String _stringValue(Object? value) => value?.toString() ?? '';

String? _nullableStringValue(Object? value) {
  if (value == null) return null;
  final text = value.toString();
  return text.isEmpty ? null : text;
}

String _ratingLabel(Object? value) {
  final rating = switch (value) {
    num() => value,
    String() => num.tryParse(value),
    _ => null,
  };

  return rating == null ? '0.0' : rating.toStringAsFixed(1);
}

String? _durationLabel(Object? value) {
  if (value == null) return null;
  if (value is num) return '${value.round()} Min';

  final text = value.toString();
  if (text.isEmpty) return null;
  return text.endsWith('Min') ? text : '$text Min';
}
