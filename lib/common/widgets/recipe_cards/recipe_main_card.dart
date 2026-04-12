import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/gen/fonts.gen.dart';
import 'recipe_card_action_button.dart';
import 'recipe_main_card_image.dart';
import 'recipe_rating_badge.dart';

class RecipeMainCard extends StatelessWidget {
  const RecipeMainCard({
    required this.title,
    required this.authorName,
    required this.description,
    required this.durationLabel,
    required this.difficultyLabel,
    required this.imagePath,
    required this.authorImagePath,
    required this.topRating,
    required this.authorRating,
    required this.onActionPressed,
    super.key,
    this.overlayImagePath =
        'assets/images/recipe_cards/main_card_content_overlay.png',
  });

  final String title;
  final String authorName;
  final String description;
  final String durationLabel;
  final String difficultyLabel;
  final String imagePath;
  final String overlayImagePath;
  final String authorImagePath;
  final String topRating;
  final String authorRating;
  final VoidCallback? onActionPressed;

  static const _designWidth = 320.0;
  static const _designHeight = 187.0;
  static const _maxResponsiveWidth = 420.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : screenWidth;
        final preferredWidth = (screenWidth / 360) * _designWidth;
        final cardWidth = math.min(
          math.min(preferredWidth, _maxResponsiveWidth),
          maxWidth,
        );
        final scale = cardWidth / _designWidth;
        final cardHeight = _designHeight * scale;

        return SizedBox(
          key: const Key('recipe_main_card'),
          width: cardWidth,
          height: cardHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned.fill(
                child: CustomPaint(
                  key: Key('recipe_main_card_background'),
                  painter: _RecipeMainCardBackgroundPainter(),
                ),
              ),
              Positioned(
                left: 6 * scale,
                top: 6 * scale,
                width: 314 * scale,
                height: 175 * scale,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: RecipeMainCardImage(
                        imagePath: imagePath,
                        overlayImagePath: overlayImagePath,
                        topRating: topRating,
                        durationLabel: durationLabel,
                        difficultyLabel: difficultyLabel,
                        scale: scale,
                      ),
                    ),
                    Positioned(
                      left: 151 * scale,
                      top: 3 * scale,
                      width: 159 * scale,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 46 * scale,
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF0E0E0E),
                                fontSize: 18 * scale,
                                fontWeight: FontWeight.w500,
                                height: 1.12,
                                fontFamily: FontFamily.montserrat,
                              ),
                            ),
                          ),
                          SizedBox(height: 6 * scale),
                          _RecipeAuthorRow(
                            authorName: authorName,
                            authorImagePath: authorImagePath,
                            authorRating: authorRating,
                            scale: scale,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 151 * scale,
                      top: 100 * scale,
                      width: 163 * scale,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 125 * scale,
                            height: 60 * scale,
                            child: Text(
                              description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF353535),
                                fontSize: 12 * scale,
                                fontWeight: FontWeight.w400,
                                height: 1.25,
                                fontFamily: FontFamily.montserrat,
                              ),
                            ),
                          ),
                          SizedBox(width: 6 * scale),
                          RecipeCardActionButton(
                            onPressed: onActionPressed,
                            scale: scale,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecipeAuthorRow extends StatelessWidget {
  const _RecipeAuthorRow({
    required this.authorName,
    required this.authorImagePath,
    required this.authorRating,
    required this.scale,
  });

  final String authorName;
  final String authorImagePath;
  final String authorRating;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            authorImagePath,
            width: 37 * scale,
            height: 37 * scale,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10 * scale),
        SizedBox(
          width: 108 * scale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF717171),
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  letterSpacing: 0.096 * scale,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
              SizedBox(height: 3 * scale),
              RecipeRatingBadge(
                rating: authorRating,
                starAssetPath: 'assets/icons/recipe_cards/star_dark.svg',
                backgroundColor: const Color(0xFFDEE21B),
                textColor: const Color(0xFF353535),
                borderRadius: 22,
                scale: scale,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecipeMainCardBackgroundPainter extends CustomPainter {
  const _RecipeMainCardBackgroundPainter();

  static const _designWidth = 320.0;
  static const _designHeight = 187.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    canvas
      ..save()
      ..scale(size.width / _designWidth, size.height / _designHeight);

    final path = Path()
      ..moveTo(308, 0)
      ..cubicTo(314.627, 0, 320, 5.37259, 320, 12)
      ..lineTo(320, 109)
      ..cubicTo(320, 113.418, 316.418, 117, 312, 117)
      ..lineTo(293, 117)
      ..cubicTo(288.582, 117, 285, 120.582, 285, 125)
      ..lineTo(285, 147)
      ..cubicTo(285, 151.418, 288.582, 155, 293, 155)
      ..lineTo(312, 155)
      ..cubicTo(316.418, 155, 320, 158.582, 320, 163)
      ..lineTo(320, 175)
      ..cubicTo(320, 181.627, 314.627, 187, 308, 187)
      ..lineTo(12, 187)
      ..cubicTo(5.37259, 187, 0, 181.627, 0, 175)
      ..lineTo(0, 12)
      ..cubicTo(0, 5.37258, 5.37258, 0, 12, 0)
      ..lineTo(308, 0)
      ..close();

    canvas
      ..drawPath(path, Paint()..color = Colors.white)
      ..drawPath(
        path,
        Paint()
          ..color = const Color(0xFFCBCBCB)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _RecipeMainCardBackgroundPainter oldDelegate) {
    return false;
  }
}
