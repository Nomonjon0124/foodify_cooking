import 'package:equatable/equatable.dart';

class ProfileView extends Equatable {
  const ProfileView({
    required this.id,
    required this.displayName,
    required this.location,
    required this.bio,
    required this.avatarUrl,
    required this.coverImageUrl,
    required this.ratingLabel,
    required this.followersLabel,
    required this.followingLabel,
    required this.postsCount,
    required this.recipes,
  });

  final String id;
  final String displayName;
  final String location;
  final String bio;
  final String avatarUrl;
  final String coverImageUrl;
  final String ratingLabel;
  final String followersLabel;
  final String followingLabel;
  final int postsCount;
  final List<ProfileRecipe> recipes;

  @override
  List<Object?> get props => [
    id,
    displayName,
    location,
    bio,
    avatarUrl,
    coverImageUrl,
    ratingLabel,
    followersLabel,
    followingLabel,
    postsCount,
    recipes,
  ];
}

class ProfileRecipe extends Equatable {
  const ProfileRecipe({
    required this.id,
    required this.title,
    required this.chefName,
    required this.ratingLabel,
    required this.durationLabel,
    required this.difficultyLabel,
    required this.description,
    required this.imageUrl,
    required this.chefAvatarUrl,
  });

  final String id;
  final String title;
  final String chefName;
  final String ratingLabel;
  final String durationLabel;
  final String difficultyLabel;
  final String description;
  final String imageUrl;
  final String chefAvatarUrl;

  @override
  List<Object?> get props => [
    id,
    title,
    chefName,
    ratingLabel,
    durationLabel,
    difficultyLabel,
    description,
    imageUrl,
    chefAvatarUrl,
  ];
}
