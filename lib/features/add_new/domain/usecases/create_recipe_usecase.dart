import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/create_recipe_draft.dart';
import '../repositories/add_new_repository.dart';

class CreateRecipeUseCase
    implements UseCase<Result<String>, CreateRecipeDraft> {
  CreateRecipeUseCase(this._repository);

  final AddNewRepository _repository;

  @override
  Future<Result<String>> call(CreateRecipeDraft params) {
    return _repository.createRecipe(params);
  }
}
