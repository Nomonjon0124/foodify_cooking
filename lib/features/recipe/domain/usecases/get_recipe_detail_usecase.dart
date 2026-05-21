import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/recipe_detail.dart';
import '../repositories/recipe_repository.dart';

class GetRecipeDetailUseCase
    implements UseCase<Result<RecipeDetail>, GetRecipeDetailParams> {
  GetRecipeDetailUseCase(this._repository);

  final RecipeRepository _repository;

  @override
  Future<Result<RecipeDetail>> call(GetRecipeDetailParams params) {
    return _repository.getRecipeDetail(params.recipeId);
  }
}

class GetRecipeDetailParams extends Equatable {
  const GetRecipeDetailParams(this.recipeId);

  final String recipeId;

  @override
  List<Object?> get props => [recipeId];
}
