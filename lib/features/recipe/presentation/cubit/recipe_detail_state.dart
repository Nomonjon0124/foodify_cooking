import 'package:equatable/equatable.dart';

import '../../domain/entities/recipe_detail.dart';

enum RecipeDetailStatus { initial, loading, success, failure }

enum RecipeDetailTab { introduction, ingredients, comments }

class RecipeDetailState extends Equatable {
  const RecipeDetailState({
    this.status = RecipeDetailStatus.initial,
    this.recipe,
    this.activeTab = RecipeDetailTab.introduction,
    this.isLikeInFlight = false,
    this.errorMessage,
  });

  final RecipeDetailStatus status;
  final RecipeDetail? recipe;
  final RecipeDetailTab activeTab;
  final bool isLikeInFlight;
  final String? errorMessage;

  RecipeDetailState copyWith({
    RecipeDetailStatus? status,
    RecipeDetail? recipe,
    RecipeDetailTab? activeTab,
    bool? isLikeInFlight,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RecipeDetailState(
      status: status ?? this.status,
      recipe: recipe ?? this.recipe,
      activeTab: activeTab ?? this.activeTab,
      isLikeInFlight: isLikeInFlight ?? this.isLikeInFlight,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    recipe,
    activeTab,
    isLikeInFlight,
    errorMessage,
  ];
}
