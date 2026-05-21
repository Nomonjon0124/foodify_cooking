import '../../domain/entities/recipe_author.dart';
import '../../domain/entities/recipe_comment.dart';
import '../../domain/entities/recipe_detail.dart';
import '../../domain/entities/recipe_ingredient.dart';
import '../../domain/entities/recipe_instruction.dart';
import '../../domain/entities/recipe_tag_badge.dart';

class RecipeDetailModel extends RecipeDetail {
  const RecipeDetailModel({
    required super.id,
    required super.title,
    required super.coverImageUrl,
    required super.ratingLabel,
    required super.likesCount,
    required super.commentsCount,
    required super.isLikedByMe,
    required super.isSavedByMe,
    required super.tags,
    required super.ingredients,
    required super.instructions,
    required super.comments,
    super.description,
    super.durationLabel,
    super.difficultyLabel,
    super.overlayImageUrl,
    super.author,
  });

  factory RecipeDetailModel.fromJson(
    Map<String, dynamic> json, {
    required int likesCount,
    required bool isLikedByMe,
    required bool isSavedByMe,
  }) {
    final authorJson = json['author'];
    final ingredientsJson = json['recipe_ingredients'];
    final instructionsJson = json['recipe_instructions'];
    final commentsJson = json['recipe_comments'];
    final tagLinksJson = json['recipe_tags'];

    final ingredients = (ingredientsJson is List)
        ? ingredientsJson
              .whereType<Map<String, dynamic>>()
              .map(RecipeIngredientModel.fromJson)
              .toList()
        : <RecipeIngredient>[];
    ingredients.sort((a, b) => a.position.compareTo(b.position));

    final instructions = (instructionsJson is List)
        ? instructionsJson
              .whereType<Map<String, dynamic>>()
              .map(RecipeInstructionModel.fromJson)
              .toList()
        : <RecipeInstruction>[];
    instructions.sort((a, b) => a.stepNumber.compareTo(b.stepNumber));

    final comments = (commentsJson is List)
        ? commentsJson
              .whereType<Map<String, dynamic>>()
              .map(RecipeCommentModel.fromJson)
              .toList()
        : <RecipeComment>[];
    comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final tags = (tagLinksJson is List)
        ? tagLinksJson
              .whereType<Map<String, dynamic>>()
              .map((row) => row['tags'])
              .whereType<Map<String, dynamic>>()
              .map(RecipeTagBadgeModel.fromJson)
              .toList()
        : <RecipeTagBadge>[];

    return RecipeDetailModel(
      id: _stringValue(json['id']),
      title: _stringValue(json['title']),
      description: _nullableStringValue(json['description']),
      coverImageUrl: _stringValue(json['cover_image_url']),
      overlayImageUrl: _nullableStringValue(json['overlay_image_url']),
      ratingLabel: _ratingLabel(json['rating']),
      durationLabel: _durationLabel(json['duration_minutes']),
      difficultyLabel: _nullableStringValue(json['difficulty']),
      likesCount: likesCount,
      commentsCount: comments.length,
      isLikedByMe: isLikedByMe,
      isSavedByMe: isSavedByMe,
      tags: tags,
      ingredients: ingredients,
      instructions: instructions,
      comments: comments,
      author: authorJson is Map<String, dynamic>
          ? RecipeAuthorModel.fromJson(authorJson)
          : null,
    );
  }
}

class RecipeAuthorModel extends RecipeAuthor {
  const RecipeAuthorModel({
    required super.id,
    required super.displayName,
    super.avatarUrl,
    super.ratingLabel,
  });

  factory RecipeAuthorModel.fromJson(Map<String, dynamic> json) {
    return RecipeAuthorModel(
      id: _stringValue(json['id']),
      displayName: _stringValue(json['display_name']),
      avatarUrl: _nullableStringValue(json['avatar_url']),
      ratingLabel: _ratingLabel(json['rating']),
    );
  }
}

class RecipeIngredientModel extends RecipeIngredient {
  const RecipeIngredientModel({
    required super.id,
    required super.position,
    required super.content,
  });

  factory RecipeIngredientModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientModel(
      id: _stringValue(json['id']),
      position: _intValue(json['position']),
      content: _stringValue(json['content']),
    );
  }
}

class RecipeInstructionModel extends RecipeInstruction {
  const RecipeInstructionModel({
    required super.id,
    required super.stepNumber,
    required super.content,
  });

  factory RecipeInstructionModel.fromJson(Map<String, dynamic> json) {
    return RecipeInstructionModel(
      id: _stringValue(json['id']),
      stepNumber: _intValue(json['step_number']),
      content: _stringValue(json['content']),
    );
  }
}

class RecipeCommentModel extends RecipeComment {
  const RecipeCommentModel({
    required super.id,
    required super.authorName,
    required super.content,
    required super.createdAt,
    super.authorAvatarUrl,
  });

  factory RecipeCommentModel.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'];
    final authorMap = authorJson is Map<String, dynamic>
        ? authorJson
        : const <String, dynamic>{};
    return RecipeCommentModel(
      id: _stringValue(json['id']),
      authorName: _stringValue(authorMap['display_name']),
      authorAvatarUrl: _nullableStringValue(authorMap['avatar_url']),
      content: _stringValue(json['content']),
      createdAt: _dateTimeValue(json['created_at']),
    );
  }
}

class RecipeTagBadgeModel extends RecipeTagBadge {
  const RecipeTagBadgeModel({required super.slug, required super.displayName});

  factory RecipeTagBadgeModel.fromJson(Map<String, dynamic> json) {
    return RecipeTagBadgeModel(
      slug: _stringValue(json['slug']),
      displayName: _stringValue(json['display_name']),
    );
  }
}

String _stringValue(Object? value) => value?.toString() ?? '';

String? _nullableStringValue(Object? value) {
  if (value == null) return null;
  final text = value.toString();
  return text.isEmpty ? null : text;
}

int _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

DateTime _dateTimeValue(Object? value) {
  if (value is DateTime) return value;
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

String _ratingLabel(Object? value) {
  final rating = switch (value) {
    num() => value,
    String() => num.tryParse(value),
    _ => null,
  };
  return rating == null ? '0.0' : rating.toStringAsFixed(1);
}

String? _durationLabel(Object? value) {
  if (value == null) return null;
  if (value is num) return '${value.round()} Min';
  final text = value.toString();
  if (text.isEmpty) return null;
  return text.endsWith('Min') ? text : '$text Min';
}
