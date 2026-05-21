import 'package:equatable/equatable.dart';

class RecipeInstruction extends Equatable {
  const RecipeInstruction({
    required this.id,
    required this.stepNumber,
    required this.content,
  });

  final String id;
  final int stepNumber;
  final String content;

  @override
  List<Object?> get props => [id, stepNumber, content];
}
