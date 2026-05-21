import 'package:equatable/equatable.dart';

class RecipeTagBadge extends Equatable {
  const RecipeTagBadge({required this.slug, required this.displayName});

  final String slug;
  final String displayName;

  @override
  List<Object?> get props => [slug, displayName];
}
