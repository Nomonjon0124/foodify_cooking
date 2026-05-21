import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/recipe_repository.dart';

class ToggleRecipeLikeUseCase
    implements UseCase<Result<RecipeLikeToggle>, ToggleRecipeLikeParams> {
  ToggleRecipeLikeUseCase(this._repository);

  final RecipeRepository _repository;

  @override
  Future<Result<RecipeLikeToggle>> call(ToggleRecipeLikeParams params) {
    return _repository.toggleLike(params.recipeId);
  }
}

class ToggleRecipeLikeParams extends Equatable {
  const ToggleRecipeLikeParams(this.recipeId);

  final String recipeId;

  @override
  List<Object?> get props => [recipeId];
}
