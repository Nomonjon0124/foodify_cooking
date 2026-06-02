import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/add_new/domain/entities/create_recipe_draft.dart';
import 'package:foodify_cooking/features/add_new/domain/repositories/add_new_repository.dart';
import 'package:foodify_cooking/features/add_new/domain/usecases/create_recipe_usecase.dart';
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

    test('selectPickedPhoto stores local image bytes for upload', () {
      final cubit = AddNewCubit();
      final bytes = Uint8List.fromList([1, 2, 3]);

      cubit.selectPickedPhoto(
        bytes: bytes,
        name: 'recipe.png',
        mimeType: 'image/png',
      );

      expect(cubit.state.phase, AddNewPhase.cropPhoto);
      expect(cubit.state.coverImageBytes, bytes);
      expect(cubit.state.coverImageName, 'recipe.png');
      expect(cubit.state.coverImageMimeType, 'image/png');
    });

    test('submitDraft sends trimmed create draft through use case', () async {
      final repository = _FakeAddNewRepository(const Success<String>('r-1'));
      final cubit = AddNewCubit(
        createRecipeUseCase: CreateRecipeUseCase(repository),
      );

      cubit
        ..selectPickedPhoto(
          bytes: Uint8List.fromList([1, 2, 3]),
          name: 'recipe.jpg',
          mimeType: 'image/jpeg',
        )
        ..confirmCrop()
        ..nextStage()
        ..updateTitle('  Palov  ')
        ..updateDescription('  Dinner recipe  ')
        ..updatePrepTime(10)
        ..updateCookTime(40)
        ..updateDifficulty('Hard')
        ..updateIngredient(0, ' Rice ')
        ..updateStep(0, ' Cook slowly ')
        ..updateHashtags('#uzbek #rice');

      await cubit.submitDraft();

      final draft = repository.lastDraft;
      expect(cubit.state.status, AddNewStatus.success);
      expect(draft?.title, 'Palov');
      expect(draft?.description, 'Dinner recipe');
      expect(draft?.durationMinutes, 50);
      expect(draft?.difficulty, 'Hard');
      expect(draft?.ingredients, ['Rice']);
      expect(draft?.instructions, ['Cook slowly']);
      expect(draft?.tags, containsAll(['Vegetarian', 'Snack', '#uzbek']));
    });

    test('submitDraft surfaces create failures', () async {
      final repository = _FakeAddNewRepository(
        const Failure<String>('Upload failed'),
      );
      final cubit = AddNewCubit(
        createRecipeUseCase: CreateRecipeUseCase(repository),
      );

      cubit
        ..selectPickedPhoto(
          bytes: Uint8List.fromList([1, 2, 3]),
          name: 'recipe.jpg',
          mimeType: 'image/jpeg',
        )
        ..updateTitle('Soup')
        ..updateIngredient(0, 'Water')
        ..updateStep(0, 'Boil');

      await cubit.submitDraft();

      expect(cubit.state.status, AddNewStatus.failure);
      expect(cubit.state.errorMessage, 'Upload failed');
    });

    test(
      'submitDraft blocks real create when no local image was picked',
      () async {
        final repository = _FakeAddNewRepository(const Success<String>('r-1'));
        final cubit = AddNewCubit(
          createRecipeUseCase: CreateRecipeUseCase(repository),
        )..selectPhoto(AddNewConstants.mockImagePaths.first);

        await cubit.submitDraft();

        expect(cubit.state.status, AddNewStatus.failure);
        expect(repository.lastDraft, isNull);
      },
    );
  });
}

class _FakeAddNewRepository implements AddNewRepository {
  _FakeAddNewRepository(this.result);

  final Result<String> result;
  CreateRecipeDraft? lastDraft;

  @override
  Future<Result<String>> createRecipe(CreateRecipeDraft draft) async {
    lastDraft = draft;
    return result;
  }
}
