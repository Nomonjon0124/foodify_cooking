import 'package:equatable/equatable.dart';

import 'recipe_author.dart';
import 'recipe_comment.dart';
import 'recipe_ingredient.dart';
import 'recipe_instruction.dart';
import 'recipe_tag_badge.dart';

class RecipeDetail extends Equatable {
  const RecipeDetail({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.ratingLabel,
    required this.likesCount,
    required this.commentsCount,
    required this.isLikedByMe,
    required this.isSavedByMe,
    required this.tags,
    required this.ingredients,
    required this.instructions,
    required this.comments,
    this.description,
    this.durationLabel,
    this.difficultyLabel,
    this.overlayImageUrl,
    this.author,
  });

  final String id;
  final String title;
  final String coverImageUrl;
  final String ratingLabel;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByMe;
  final bool isSavedByMe;
  final List<RecipeTagBadge> tags;
  final List<RecipeIngredient> ingredients;
  final List<RecipeInstruction> instructions;
  final List<RecipeComment> comments;
  final String? description;
  final String? durationLabel;
  final String? difficultyLabel;
  final String? overlayImageUrl;
  final RecipeAuthor? author;

  RecipeDetail copyWith({
    int? likesCount,
    bool? isLikedByMe,
    bool? isSavedByMe,
  }) {
    return RecipeDetail(
      id: id,
      title: title,
      coverImageUrl: coverImageUrl,
      ratingLabel: ratingLabel,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      isSavedByMe: isSavedByMe ?? this.isSavedByMe,
      tags: tags,
      ingredients: ingredients,
      instructions: instructions,
      comments: comments,
      description: description,
      durationLabel: durationLabel,
      difficultyLabel: difficultyLabel,
      overlayImageUrl: overlayImageUrl,
      author: author,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    coverImageUrl,
    ratingLabel,
    likesCount,
    commentsCount,
    isLikedByMe,
    isSavedByMe,
    tags,
    ingredients,
    instructions,
    comments,
    description,
    durationLabel,
    difficultyLabel,
    overlayImageUrl,
    author,
  ];
}
