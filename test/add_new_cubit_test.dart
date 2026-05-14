import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/features/add_new/presentation/add_new_constants.dart';
import 'package:foodify_cooking/features/add_new/presentation/cubit/add_new_cubit.dart';

void main() {
  group('AddNewCubit', () {
    test('walks through the planned add new flow and resets cleanly', () async {
      final cubit = AddNewCubit();
      final imagePath = AddNewConstants.mockImagePaths.first;

      expect(cubit.state.phase, AddNewPhase.photoPicker);
      expect(cubit.state.mockComments, isNotEmpty);

      cubit.selectPhoto(imagePath);
      expect(cubit.state.coverImagePath, imagePath);
      expect(cubit.state.phase, AddNewPhase.cropPhoto);

      cubit.confirmCrop();
      expect(cubit.state.phase, AddNewPhase.coverPreview);

      cubit.nextStage();
      expect(cubit.state.phase, AddNewPhase.formSteps);
      expect(cubit.state.currentStep, 0);

      cubit.updateTitle('Perfect homemade pancake');
      cubit.nextStage();
      expect(cubit.state.currentStep, 1);

      cubit.updateIngredient(0, '2 cups flour');
      cubit.nextStage();
      expect(cubit.state.currentStep, 2);

      cubit.updateStep(0, 'Mix everything together');
      cubit.nextStage();
      expect(cubit.state.phase, AddNewPhase.recipePreview);
      expect(cubit.state.previewTab, RecipePreviewTab.introduction);

      cubit.setPreviewTab(RecipePreviewTab.comments);
      expect(cubit.state.previewTab, RecipePreviewTab.comments);

      await cubit.submitDraft();
      expect(cubit.state.status, AddNewStatus.success);

      cubit.clearDraft();
      expect(cubit.state.phase, AddNewPhase.photoPicker);
      expect(cubit.state.coverImagePath, isEmpty);
      expect(cubit.state.title, isEmpty);
    });
  });
}
