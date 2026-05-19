import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/saved_recipes_repository.dart';

class UnsaveRecipeUseCase implements UseCase<Result<void>, UnsaveRecipeParams> {
  UnsaveRecipeUseCase(this._repository);

  final SavedRecipesRepository _repository;

  @override
  Future<Result<void>> call(UnsaveRecipeParams params) {
    return _repository.unsaveRecipe(params.recipeId);
  }
}

class UnsaveRecipeParams extends Equatable {
  const UnsaveRecipeParams(this.recipeId);

  final String recipeId;

  @override
  List<Object?> get props => [recipeId];
}
