import 'package:equatable/equatable.dart';

class HomeFeed extends Equatable {
  const HomeFeed({required this.popularRecipes, required this.latestRecipes});

  const HomeFeed.empty()
    : popularRecipes = const <HomeRecipe>[],
      latestRecipes = const <HomeRecipe>[];

  final List<HomeRecipe> popularRecipes;
  final List<HomeRecipe> latestRecipes;

  @override
  List<Object?> get props => [popularRecipes, latestRecipes];
}

class HomeRecipe extends Equatable {
  const HomeRecipe({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.topRatingLabel,
    this.description,
    this.durationLabel,
    this.difficultyLabel,
    this.overlayImageUrl,
    this.author,
  });

  final String id;
  final String title;
  final String coverImageUrl;
  final String topRatingLabel;
  final String? description;
  final String? durationLabel;
  final String? difficultyLabel;
  final String? overlayImageUrl;
  final HomeProfile? author;

  @override
  List<Object?> get props => [
    id,
    title,
    coverImageUrl,
    topRatingLabel,
    description,
    durationLabel,
    difficultyLabel,
    overlayImageUrl,
    author,
  ];
}

class HomeProfile extends Equatable {
  const HomeProfile({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    this.ratingLabel,
  });

  final String id;
  final String displayName;
  final String? avatarUrl;
  final String? ratingLabel;

  @override
  List<Object?> get props => [id, displayName, avatarUrl, ratingLabel];
}
