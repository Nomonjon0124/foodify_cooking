import 'package:equatable/equatable.dart';

class RecipeIngredient extends Equatable {
  const RecipeIngredient({
    required this.id,
    required this.position,
    required this.content,
  });

  final String id;
  final int position;
  final String content;

  @override
  List<Object?> get props => [id, position, content];
}
