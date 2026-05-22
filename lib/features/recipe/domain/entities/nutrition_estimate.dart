import 'package:equatable/equatable.dart';

class NutritionEstimate extends Equatable {
  const NutritionEstimate({
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final double kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;

  @override
  List<Object?> get props => [kcal, proteinG, carbsG, fatG];
}
