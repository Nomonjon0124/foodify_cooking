import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/gen/fonts.gen.dart';

class RecipeRatingBadge extends StatelessWidget {
  const RecipeRatingBadge({
    required this.rating,
    required this.starAssetPath,
    required this.backgroundColor,
    required this.textColor,
    super.key,
    this.borderRadius = 4,
    this.scale = 1,
  });

  final String rating;
  final String starAssetPath;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18 * scale,
      padding: EdgeInsets.symmetric(horizontal: 5 * scale, vertical: 4 * scale),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius * scale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            starAssetPath,
            width: 12 * scale,
            height: 12 * scale,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          SizedBox(width: 4 * scale),
          Text(
            rating,
            style: TextStyle(
              color: textColor,
              fontSize: 11 * scale,
              fontWeight: FontWeight.w400,
              height: 1,
              fontFamily: FontFamily.montserrat,
            ),
          ),
        ],
      ),
    );
  }
}
