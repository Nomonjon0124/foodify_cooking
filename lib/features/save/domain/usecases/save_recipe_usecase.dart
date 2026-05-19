import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/saved_recipes_repository.dart';

class SaveRecipeUseCase implements UseCase<Result<void>, SaveRecipeParams> {
  SaveRecipeUseCase(this._repository);

  final SavedRecipesRepository _repository;

  @override
  Future<Result<void>> call(SaveRecipeParams params) {
    return _repository.saveRecipe(params.recipeId);
  }
}

class SaveRecipeParams extends Equatable {
  const SaveRecipeParams(this.recipeId);

  final String recipeId;

  @override
  List<Object?> get props => [recipeId];
}
