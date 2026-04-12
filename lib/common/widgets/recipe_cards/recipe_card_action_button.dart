import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecipeCardActionButton extends StatelessWidget {
  const RecipeCardActionButton({
    required this.onPressed,
    super.key,
    this.iconPath = 'assets/icons/recipe_cards/send.svg',
    this.scale = 1,
  });

  final VoidCallback? onPressed;
  final String iconPath;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        key: const Key('recipe_card_action_button'),
        width: 32 * scale,
        height: 32 * scale,
        padding: EdgeInsets.all(2 * scale),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6339),
          borderRadius: BorderRadius.circular(7 * scale),
        ),
        child: Center(
          child: Transform.rotate(
            angle: math.pi,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(1, -1, 1),
              child: SvgPicture.asset(
                iconPath,
                width: 18 * scale,
                height: 18 * scale,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
