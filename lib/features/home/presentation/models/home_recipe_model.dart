class PopularRecipeSample {
  const PopularRecipeSample({
    required this.title,
    required this.rating,
    required this.imagePath,
  });

  final String title;
  final String rating;
  final String imagePath;
}

class LatestRecipeSample {
  const LatestRecipeSample({
    required this.title,
    required this.authorName,
    required this.description,
    required this.durationLabel,
    required this.difficultyLabel,
    required this.imagePath,
    required this.overlayImagePath,
    required this.authorImagePath,
    required this.topRating,
    required this.authorRating,
  });

  final String title;
  final String authorName;
  final String description;
  final String durationLabel;
  final String difficultyLabel;
  final String imagePath;
  final String overlayImagePath;
  final String authorImagePath;
  final String topRating;
  final String authorRating;
}
