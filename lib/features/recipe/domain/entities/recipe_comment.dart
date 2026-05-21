import 'package:equatable/equatable.dart';

class RecipeComment extends Equatable {
  const RecipeComment({
    required this.id,
    required this.authorName,
    required this.content,
    required this.createdAt,
    this.authorAvatarUrl,
  });

  final String id;
  final String authorName;
  final String content;
  final DateTime createdAt;
  final String? authorAvatarUrl;

  @override
  List<Object?> get props => [
    id,
    authorName,
    content,
    createdAt,
    authorAvatarUrl,
  ];
}
