import 'package:equatable/equatable.dart';

enum RecipeStatus { initial, loading, success, failure }

class RecipeState extends Equatable {
  const RecipeState({
    this.status = RecipeStatus.initial,
    this.recipes = const <String>[],
    this.errorMessage,
  });

  final RecipeStatus status;
  final List<String> recipes;
  final String? errorMessage;

  RecipeState copyWith({
    RecipeStatus? status,
    List<String>? recipes,
    String? errorMessage,
  }) {
    return RecipeState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recipes, errorMessage];
}
