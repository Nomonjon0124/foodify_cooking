import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';

import '../../../core/gen/fonts.gen.dart';

enum FoodifyPopularCardState {
  defaultView,
  toBeSelected,
  selected,
  toBeSaved,
  saved,
}

class FoodifyPopularCard extends StatelessWidget {
  const FoodifyPopularCard({
    super.key,
    this.title = 'chocolate cake with buttercream frosting',
    this.rating = '4.8',
    this.imagePath,
    this.state = FoodifyPopularCardState.defaultView,
    this.onTap,
    this.onSelectPressed,
    this.onSavePressed,
  });

  final String title;
  final String rating;
  final Widget? imagePath;
  final FoodifyPopularCardState state;
  final VoidCallback? onTap;
  final VoidCallback? onSelectPressed;
  final VoidCallback? onSavePressed;

  static const _designWidth = 156.0;
  static const _designHeight = 199.0;
  static const _maxResponsiveWidth = 220.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final targetWidth = 156.r;
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final cardWidth = math.min(
          math.min(targetWidth, _maxResponsiveWidth.r),
          maxWidth,
        );
        final scale = cardWidth / _designWidth;
        final cardHeight = _designHeight * scale;

        return SizedBox(
          key: const Key('foodify_popular_card'),
          width: cardWidth,
          height: cardHeight,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8 * scale),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imagePath ??
                      Assets.images.foodifyComponents.popularCardCake.image(),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 70 * scale,
                    child: _PopularCardCaption(title: title, scale: scale),
                  ),
                  Positioned(
                    left: 8 * scale,
                    right: 8 * scale,
                    top: 8 * scale,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Recipe rating badge hidden.
                        // _PopularCardRatingBadge(rating: rating, scale: scale),
                        const SizedBox.shrink(),
                        _PopularCardStateAction(
                          state: state,
                          scale: scale,
                          onSelectPressed: onSelectPressed,
                          onSavePressed: onSavePressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PopularCardCaption extends StatelessWidget {
  const _PopularCardCaption({required this.title, required this.scale});

  final String title;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10 * scale)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Colors.black],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8 * scale,
              vertical: 12 * scale,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Recipe rating badge hidden (recipe rating display disabled).
// class _PopularCardRatingBadge extends StatelessWidget {
//   const _PopularCardRatingBadge({required this.rating, required this.scale});
//
//   final String rating;
//   final double scale;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       key: const Key('foodify_popular_card_rating'),
//       height: 18 * scale,
//       padding: EdgeInsets.symmetric(horizontal: 5 * scale, vertical: 4 * scale),
//       decoration: BoxDecoration(
//         color: const Color(0xFF353535),
//         borderRadius: BorderRadius.circular(4 * scale),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Assets.icons.recipeCards.starWhite.svg(
//             width: 12 * scale,
//             height: 12 * scale,
//             colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//           ),
//           SizedBox(width: 4 * scale),
//           Text(
//             rating,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 11 * scale,
//               fontWeight: FontWeight.w400,
//               height: 1,
//               fontFamily: FontFamily.montserrat,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _PopularCardStateAction extends StatelessWidget {
  const _PopularCardStateAction({
    required this.state,
    required this.scale,
    required this.onSelectPressed,
    required this.onSavePressed,
  });

  final FoodifyPopularCardState state;
  final double scale;
  final VoidCallback? onSelectPressed;
  final VoidCallback? onSavePressed;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      FoodifyPopularCardState.defaultView => SizedBox(width: 18 * scale),
      FoodifyPopularCardState.toBeSelected => _SelectCircle(
        scale: scale,
        isSelected: false,
        onPressed: onSelectPressed,
      ),
      FoodifyPopularCardState.selected => _SelectCircle(
        scale: scale,
        isSelected: true,
        onPressed: onSelectPressed,
      ),
      FoodifyPopularCardState.toBeSaved => _SaveIcon(
        scale: scale,
        isSaved: false,
        onPressed: onSavePressed,
      ),
      FoodifyPopularCardState.saved => _SaveIcon(
        scale: scale,
        isSaved: true,
        onPressed: onSavePressed,
      ),
    };
  }
}

class _SelectCircle extends StatelessWidget {
  const _SelectCircle({
    required this.scale,
    required this.isSelected,
    required this.onPressed,
  });

  final double scale;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final circle = AnimatedContainer(
      key: const Key('foodify_popular_card_select_circle'),
      duration: const Duration(milliseconds: 160),
      width: 18 * scale,
      height: 18 * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFF05B5BF) : Colors.transparent,
        border: Border.all(color: Colors.white, width: 1 * scale),
      ),
      child: isSelected
          ? CustomPaint(painter: _SelectCheckPainter(scale: scale))
          : null,
    );

    if (onPressed == null) return circle;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: circle,
    );
  }
}

class _SelectCheckPainter extends CustomPainter {
  const _SelectCheckPainter({required this.scale});

  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.6 * scale;

    final path = Path()
      ..moveTo(size.width * 0.32, size.height * 0.52)
      ..lineTo(size.width * 0.45, size.height * 0.65)
      ..lineTo(size.width * 0.7, size.height * 0.38);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SelectCheckPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}

class _SaveIcon extends StatelessWidget {
  const _SaveIcon({
    required this.scale,
    required this.isSaved,
    required this.onPressed,
  });

  final double scale;
  final bool isSaved;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = isSaved
        ? Assets.icons.foodifyComponents.archiveMinusBold.svg(
            key: const Key('foodify_popular_card_save_icon'),
            width: 16 * scale,
            height: 16 * scale,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          )
        : Assets.icons.foodifyComponents.archiveMinusOutline.svg(
            width: 16 * scale,
            key: const Key('foodify_popular_card_unsave_icon'),
            height: 16 * scale,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          );

    if (onPressed == null) return icon;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: icon,
    );
  }
}
