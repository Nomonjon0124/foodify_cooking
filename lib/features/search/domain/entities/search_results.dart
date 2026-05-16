import 'package:equatable/equatable.dart';

class SearchResults extends Equatable {
  const SearchResults({
    required this.recipes,
    required this.chefs,
    required this.tags,
  });

  const SearchResults.empty()
    : recipes = const <SearchRecipe>[],
      chefs = const <SearchChef>[],
      tags = const <SearchTag>[];

  final List<SearchRecipe> recipes;
  final List<SearchChef> chefs;
  final List<SearchTag> tags;

  @override
  List<Object?> get props => [recipes, chefs, tags];
}

class SearchRecipe extends Equatable {
  const SearchRecipe({
    required this.id,
    required this.title,
    required this.ratingLabel,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String ratingLabel;
  final String imageUrl;

  @override
  List<Object?> get props => [id, title, ratingLabel, imageUrl];
}

class SearchChef extends Equatable {
  const SearchChef({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  final String id;
  final String name;
  final String avatarUrl;

  @override
  List<Object?> get props => [id, name, avatarUrl];
}

class SearchTag extends Equatable {
  const SearchTag({required this.id, required this.displayName});

  final String id;
  final String displayName;

  @override
  List<Object?> get props => [id, displayName];
}
