import '../../domain/entities/search_results.dart';

class SearchResultsModel extends SearchResults {
  const SearchResultsModel({
    required super.recipes,
    required super.chefs,
    required super.tags,
  });
}

class SearchRecipeModel extends SearchRecipe {
  const SearchRecipeModel({
    required super.id,
    required super.title,
    required super.ratingLabel,
    required super.imageUrl,
  });

  factory SearchRecipeModel.fromJson(Map<String, dynamic> json) {
    return SearchRecipeModel(
      id: _stringValue(json['id']),
      title: _stringValue(json['title']),
      ratingLabel: _ratingLabel(json['rating']),
      imageUrl: _stringValue(json['cover_image_url']),
    );
  }
}

class SearchChefModel extends SearchChef {
  const SearchChefModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
  });

  factory SearchChefModel.fromJson(Map<String, dynamic> json) {
    return SearchChefModel(
      id: _stringValue(json['id']),
      name: _stringValue(json['display_name']),
      avatarUrl: _stringValue(json['avatar_url']),
    );
  }
}

class SearchTagModel extends SearchTag {
  const SearchTagModel({required super.id, required super.displayName});

  factory SearchTagModel.fromJson(Map<String, dynamic> json) {
    return SearchTagModel(
      id: _stringValue(json['id']),
      displayName: _stringValue(json['display_name']),
    );
  }
}

String _stringValue(Object? value) => value?.toString() ?? '';

String _ratingLabel(Object? value) {
  final rating = switch (value) {
    num() => value,
    String() => num.tryParse(value),
    _ => null,
  };

  return rating == null ? '0.0' : rating.toStringAsFixed(1);
}
