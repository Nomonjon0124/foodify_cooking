import 'package:flutter/material.dart';

import '../../../common/widgets/foodify_image.dart';
import '../../../core/gen/fonts.gen.dart';
// Rating badge hidden (recipe rating display disabled).
// import 'recipe_rating_badge.dart';

class RecipeMainCardImage extends StatelessWidget {
  const RecipeMainCardImage({
    required this.imagePath,
    required this.overlayImagePath,
    required this.topRating,
    required this.durationLabel,
    required this.difficultyLabel,
    super.key,
    this.scale = 1,
  });

  final String imagePath;
  final String overlayImagePath;
  final String topRating;
  final String durationLabel;
  final String difficultyLabel;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10 * scale),
      child: SizedBox(
        width: 138 * scale,
        height: 175 * scale,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FoodifyImage(imagePath, fit: BoxFit.cover),
            if (overlayImagePath.isNotEmpty)
              FoodifyImage(overlayImagePath, fit: BoxFit.cover),
            // Recipe rating badge hidden.
            // Positioned(
            //   left: 8 * scale,
            //   top: 8 * scale,
            //   child: RecipeRatingBadge(
            //     rating: topRating,
            //     starAssetPath: 'assets/icons/recipe_cards/star_white.svg',
            //     backgroundColor: const Color(0xFF353535),
            //     textColor: Colors.white,
            //     scale: scale,
            //   ),
            // ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 101 * scale,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF030303).withValues(alpha: 0),
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18 * scale,
              right: 18 * scale,
              bottom: 16 * scale,
              child: SizedBox(
                width: 120 * scale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _MetaText(durationLabel, scale: scale)),
                    SizedBox(width: 9 * scale),
                    Container(
                      width: 1 * scale,
                      height: 13 * scale,
                      color: const Color(0xFFFFD9CD),
                    ),
                    SizedBox(width: 9 * scale),
                    Expanded(child: _MetaText(difficultyLabel, scale: scale)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text, {required this.scale});

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12 * scale,
        fontWeight: FontWeight.w400,
        height: 1,
        fontFamily: FontFamily.montserrat,
      ),
    );
  }
}
