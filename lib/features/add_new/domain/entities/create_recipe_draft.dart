import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class CreateRecipeDraft extends Equatable {
  const CreateRecipeDraft({
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.difficulty,
    required this.coverImageBytes,
    required this.coverImageName,
    required this.coverImageMimeType,
    required this.ingredients,
    required this.instructions,
    required this.tags,
  });

  final String title;
  final String description;
  final int durationMinutes;
  final String difficulty;
  final Uint8List coverImageBytes;
  final String coverImageName;
  final String coverImageMimeType;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> tags;

  @override
  List<Object?> get props => [
    title,
    description,
    durationMinutes,
    difficulty,
    coverImageBytes,
    coverImageName,
    coverImageMimeType,
    ingredients,
    instructions,
    tags,
  ];
}
