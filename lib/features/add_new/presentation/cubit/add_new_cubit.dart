import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/create_recipe_draft.dart';
import '../../domain/usecases/create_recipe_usecase.dart';
import '../add_new_constants.dart';

enum AddNewStatus { initial, loading, success, failure }

enum AddNewPhase {
  photoPicker,
  cropPhoto,
  coverPreview,
  formSteps,
  recipePreview,
}

enum RecipePreviewTab { introduction, ingredients, comments }

class AddNewState extends Equatable {
  const AddNewState({
    this.phase = AddNewPhase.photoPicker,
    this.currentStep = 0,
    this.previewTab = RecipePreviewTab.introduction,
    this.status = AddNewStatus.initial,
    this.coverImagePath = '',
    this.coverImageBytes,
    this.coverImageName = '',
    this.coverImageMimeType = 'image/jpeg',
    this.cropQuarterTurns = 0,
    this.title = '',
    this.description = '',
    this.servings = 4,
    this.prepTime = 0,
    this.cookTime = 48,
    this.difficulty = 'Medium',
    this.ingredients = const [''],
    this.steps = const [''],
    this.tags = const ['Vegetarian', 'Low Fat', 'Sugar Free'],
    this.category = 'Snack',
    this.calories = 320,
    this.protein = 12,
    this.fat = 8,
    this.carbs = 24,
    this.hashtags = '#egg #Vegan #Sugerfree #lowfat',
    this.mockComments = const [],
    this.errorMessage = '',
  });

  final AddNewPhase phase;
  final int currentStep;
  final RecipePreviewTab previewTab;
  final AddNewStatus status;
  final String coverImagePath;
  final Uint8List? coverImageBytes;
  final String coverImageName;
  final String coverImageMimeType;
  final int cropQuarterTurns;
  final String title;
  final String description;
  final int servings;
  final int prepTime;
  final int cookTime;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> tags;
  final String category;
  final int calories;
  final int protein;
  final int fat;
  final int carbs;
  final String hashtags;
  final List<AddNewComment> mockComments;
  final String errorMessage;

  bool get hasCover =>
      coverImageBytes != null || coverImagePath.trim().isNotEmpty;
  bool get hasPickedCover => coverImageBytes != null;
  bool get hasTitle => title.trim().isNotEmpty;
  bool get hasValidIngredients =>
      ingredients.any((ingredient) => ingredient.trim().isNotEmpty);
  bool get hasValidSteps => steps.any((step) => step.trim().isNotEmpty);
  bool get isSubmitting => status == AddNewStatus.loading;
  bool get isSubmitSuccess => status == AddNewStatus.success;
  bool get isStepValid {
    switch (phase) {
      case AddNewPhase.photoPicker:
      case AddNewPhase.cropPhoto:
      case AddNewPhase.coverPreview:
        return hasCover;
      case AddNewPhase.formSteps:
        switch (currentStep) {
          case 0:
            return hasTitle;
          case 1:
            return hasValidIngredients;
          case 2:
            return hasValidSteps;
          default:
            return true;
        }
      case AddNewPhase.recipePreview:
        return true;
    }
  }

  String get cookTimeLabel {
    final hours = cookTime ~/ 60;
    final minutes = cookTime % 60;
    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h';
    return '${minutes}m';
  }

  String get previewTitle =>
      title.trim().isEmpty ? 'Perfect homemade pancake' : title.trim();

  String get headlineTag {
    if (tags.isNotEmpty) return tags.first;
    if (category.trim().isNotEmpty) return category.trim();
    return 'Low Callery';
  }

  AddNewState copyWith({
    AddNewPhase? phase,
    int? currentStep,
    RecipePreviewTab? previewTab,
    AddNewStatus? status,
    String? coverImagePath,
    Uint8List? coverImageBytes,
    String? coverImageName,
    String? coverImageMimeType,
    bool clearCoverImageBytes = false,
    int? cropQuarterTurns,
    String? title,
    String? description,
    int? servings,
    int? prepTime,
    int? cookTime,
    String? difficulty,
    List<String>? ingredients,
    List<String>? steps,
    List<String>? tags,
    String? category,
    int? calories,
    int? protein,
    int? fat,
    int? carbs,
    String? hashtags,
    List<AddNewComment>? mockComments,
    String? errorMessage,
  }) {
    return AddNewState(
      phase: phase ?? this.phase,
      currentStep: currentStep ?? this.currentStep,
      previewTab: previewTab ?? this.previewTab,
      status: status ?? this.status,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      coverImageBytes: clearCoverImageBytes
          ? null
          : (coverImageBytes ?? this.coverImageBytes),
      coverImageName: coverImageName ?? this.coverImageName,
      coverImageMimeType: coverImageMimeType ?? this.coverImageMimeType,
      cropQuarterTurns: cropQuarterTurns ?? this.cropQuarterTurns,
      title: title ?? this.title,
      description: description ?? this.description,
      servings: servings ?? this.servings,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      hashtags: hashtags ?? this.hashtags,
      mockComments: mockComments ?? this.mockComments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    phase,
    currentStep,
    previewTab,
    status,
    coverImagePath,
    coverImageBytes,
    coverImageName,
    coverImageMimeType,
    cropQuarterTurns,
    title,
    description,
    servings,
    prepTime,
    cookTime,
    difficulty,
    ingredients,
    steps,
    tags,
    category,
    calories,
    protein,
    fat,
    carbs,
    hashtags,
    mockComments,
    errorMessage,
  ];
}

class AddNewCubit extends Cubit<AddNewState> {
  AddNewCubit({CreateRecipeUseCase? createRecipeUseCase})
    : _createRecipeUseCase = createRecipeUseCase,
      super(AddNewState(mockComments: AddNewConstants.mockComments));

  final CreateRecipeUseCase? _createRecipeUseCase;

  bool canContinueCurrentStage() => state.isStepValid && !state.isSubmitting;

  bool handleBack() {
    switch (state.phase) {
      case AddNewPhase.photoPicker:
        return false;
      case AddNewPhase.cropPhoto:
        emit(state.copyWith(phase: AddNewPhase.photoPicker));
        return true;
      case AddNewPhase.coverPreview:
        emit(state.copyWith(phase: AddNewPhase.photoPicker));
        return true;
      case AddNewPhase.formSteps:
        if (state.currentStep > 0) {
          emit(state.copyWith(currentStep: state.currentStep - 1));
        } else {
          emit(state.copyWith(phase: AddNewPhase.coverPreview));
        }
        return true;
      case AddNewPhase.recipePreview:
        emit(state.copyWith(phase: AddNewPhase.formSteps, currentStep: 2));
        return true;
    }
  }

  void selectPhoto(String path) {
    emit(
      state.copyWith(
        coverImagePath: path,
        clearCoverImageBytes: true,
        coverImageName: '',
        coverImageMimeType: 'image/jpeg',
        phase: AddNewPhase.cropPhoto,
        status: AddNewStatus.initial,
        errorMessage: '',
      ),
    );
  }

  void selectPickedPhoto({
    required Uint8List bytes,
    required String name,
    required String mimeType,
  }) {
    if (bytes.isEmpty) return;
    emit(
      state.copyWith(
        coverImagePath: name,
        coverImageBytes: bytes,
        coverImageName: name,
        coverImageMimeType: mimeType.isEmpty ? 'image/jpeg' : mimeType,
        cropQuarterTurns: 0,
        phase: AddNewPhase.cropPhoto,
        status: AddNewStatus.initial,
        errorMessage: '',
      ),
    );
  }

  void startCrop() {
    if (!state.hasCover) return;
    emit(state.copyWith(phase: AddNewPhase.cropPhoto));
  }

  void rotateCrop() {
    emit(state.copyWith(cropQuarterTurns: (state.cropQuarterTurns + 1) % 4));
  }

  void cancelCrop() {
    emit(state.copyWith(phase: AddNewPhase.photoPicker));
  }

  void confirmCrop() => goToCoverPreview();

  void goToCoverPreview() {
    if (!state.hasCover) return;
    emit(state.copyWith(phase: AddNewPhase.coverPreview));
  }

  void editCrop() {
    if (!state.hasCover) return;
    emit(state.copyWith(phase: AddNewPhase.cropPhoto));
  }

  void removeCover() {
    emit(
      state.copyWith(
        coverImagePath: '',
        clearCoverImageBytes: true,
        coverImageName: '',
        coverImageMimeType: 'image/jpeg',
        cropQuarterTurns: 0,
        phase: AddNewPhase.photoPicker,
      ),
    );
  }

  void nextStage() {
    switch (state.phase) {
      case AddNewPhase.photoPicker:
        startCrop();
      case AddNewPhase.cropPhoto:
        goToCoverPreview();
      case AddNewPhase.coverPreview:
        emit(state.copyWith(phase: AddNewPhase.formSteps, currentStep: 0));
      case AddNewPhase.formSteps:
        if (state.currentStep < 2) {
          emit(state.copyWith(currentStep: state.currentStep + 1));
        } else {
          goToRecipePreview();
        }
      case AddNewPhase.recipePreview:
        submitDraft();
    }
  }

  void goToRecipePreview() {
    emit(
      state.copyWith(
        phase: AddNewPhase.recipePreview,
        previewTab: RecipePreviewTab.introduction,
      ),
    );
  }

  void setPreviewTab(RecipePreviewTab tab) {
    emit(state.copyWith(previewTab: tab));
  }

  void clearDraft() {
    emit(AddNewState(mockComments: AddNewConstants.mockComments));
  }

  void resetStatus() {
    emit(state.copyWith(status: AddNewStatus.initial, errorMessage: ''));
  }

  void updateTitle(String value) => emit(state.copyWith(title: value));
  void updateDescription(String value) =>
      emit(state.copyWith(description: value));
  void updateServings(int value) {
    emit(state.copyWith(servings: value.clamp(1, 99)));
  }

  void updatePrepTime(int value) => emit(state.copyWith(prepTime: value));
  void updateCookTime(int value) => emit(state.copyWith(cookTime: value));
  void updateDifficulty(String value) =>
      emit(state.copyWith(difficulty: value));
  void updateCategory(String value) => emit(state.copyWith(category: value));
  void updateCalories(int value) => emit(state.copyWith(calories: value));
  void updateProtein(int value) => emit(state.copyWith(protein: value));
  void updateFat(int value) => emit(state.copyWith(fat: value));
  void updateCarbs(int value) => emit(state.copyWith(carbs: value));
  void updateHashtags(String value) => emit(state.copyWith(hashtags: value));

  void toggleTag(String tag) {
    final newTags = List<String>.from(state.tags);
    if (newTags.contains(tag)) {
      newTags.remove(tag);
    } else {
      newTags.add(tag);
    }
    emit(state.copyWith(tags: newTags));
  }

  void addIngredient() {
    emit(state.copyWith(ingredients: [...state.ingredients, '']));
  }

  void updateIngredient(int index, String value) {
    final newIngredients = List<String>.from(state.ingredients);
    if (index < 0 || index >= newIngredients.length) return;
    newIngredients[index] = value;
    emit(state.copyWith(ingredients: newIngredients));
  }

  void removeIngredient(int index) {
    if (state.ingredients.length <= 1) return;
    final newIngredients = List<String>.from(state.ingredients)
      ..removeAt(index);
    emit(state.copyWith(ingredients: newIngredients));
  }

  void addStep() {
    emit(state.copyWith(steps: [...state.steps, '']));
  }

  void updateStep(int index, String value) {
    final newSteps = List<String>.from(state.steps);
    if (index < 0 || index >= newSteps.length) return;
    newSteps[index] = value;
    emit(state.copyWith(steps: newSteps));
  }

  void removeStep(int index) {
    if (state.steps.length <= 1) return;
    final newSteps = List<String>.from(state.steps)..removeAt(index);
    emit(state.copyWith(steps: newSteps));
  }

  Future<void> submitDraft() async {
    if (state.isSubmitting) return;
    emit(state.copyWith(status: AddNewStatus.loading, errorMessage: ''));
    final createRecipeUseCase = _createRecipeUseCase;
    if (createRecipeUseCase == null) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      emit(state.copyWith(status: AddNewStatus.success));
      return;
    }

    final bytes = state.coverImageBytes;
    if (bytes == null) {
      emit(
        state.copyWith(
          status: AddNewStatus.failure,
          errorMessage: 'Choose a photo from gallery or camera',
        ),
      );
      return;
    }

    final result = await createRecipeUseCase(_createDraft(bytes));
    result.fold(
      (message) => emit(
        state.copyWith(status: AddNewStatus.failure, errorMessage: message),
      ),
      (_) => emit(state.copyWith(status: AddNewStatus.success)),
    );
  }

  CreateRecipeDraft _createDraft(Uint8List coverImageBytes) {
    return CreateRecipeDraft(
      title: state.title.trim(),
      description: state.description.trim(),
      durationMinutes: state.prepTime + state.cookTime,
      difficulty: state.difficulty,
      coverImageBytes: coverImageBytes,
      coverImageName: state.coverImageName.isEmpty
          ? 'cover.jpg'
          : state.coverImageName,
      coverImageMimeType: state.coverImageMimeType,
      ingredients: state.ingredients
          .map((ingredient) => ingredient.trim())
          .where((ingredient) => ingredient.isNotEmpty)
          .toList(),
      instructions: state.steps
          .map((step) => step.trim())
          .where((step) => step.isNotEmpty)
          .toList(),
      tags: _recipeTags(),
    );
  }

  List<String> _recipeTags() {
    final values = <String>{
      ...state.tags.map((tag) => tag.trim()).where((tag) => tag.isNotEmpty),
      if (state.category.trim().isNotEmpty) state.category.trim(),
      ...state.hashtags
          .split(RegExp(r'\s+'))
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty),
    };
    return values.toList(growable: false);
  }
}
