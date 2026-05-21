import 'package:equatable/equatable.dart';

class RecipeAuthor extends Equatable {
  const RecipeAuthor({
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
