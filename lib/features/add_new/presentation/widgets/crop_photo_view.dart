import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/l10n_extension.dart';

class CropPhotoView extends StatelessWidget {
  const CropPhotoView({
    required this.imagePath,
    required this.quarterTurns,
    required this.onCancel,
    required this.onDone,
    required this.onRotate,
    super.key,
  });

  final String imagePath;
  final int quarterTurns;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final VoidCallback onRotate;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RotatedBox(
            quarterTurns: quarterTurns,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          CustomPaint(painter: _CropOverlayPainter()),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                children: [
                  GestureDetector(
                    key: const Key('crop-cancel-button'),
                    onTap: onCancel,
                    child: Text(
                      context.l10n.addNewCropCancel,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    key: const Key('crop-done-button'),
                    onTap: onDone,
                    child: Text(
                      context.l10n.addNewCropDone,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 72.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                key: const Key('crop-rotate-button'),
                onTap: onRotate,
                child: Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 24.r,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cropWidth = math.min(size.width - 50, 310.w);
    final cropHeight = 210.h;
    final cropLeft = (size.width - cropWidth) / 2;
    final cropTop = (size.height - cropHeight) / 2;
    final cropRect = Rect.fromLTWH(cropLeft, cropTop, cropWidth, cropHeight);

    final maskPaint = Paint()..color = Colors.black.withValues(alpha: 0.54);
    final fullPath = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(cropRect, Radius.circular(6.r)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(fullPath, maskPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(cropRect, Radius.circular(6.r)),
      borderPaint,
    );

    final handlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    const handleLength = 18.0;

    void drawCorner(Offset start, bool isRight, bool isBottom) {
      canvas.drawLine(
        start,
        start + Offset(isRight ? -handleLength : handleLength, 0),
        handlePaint,
      );
      canvas.drawLine(
        start,
        start + Offset(0, isBottom ? -handleLength : handleLength),
        handlePaint,
      );
    }

    drawCorner(cropRect.topLeft, false, false);
    drawCorner(cropRect.topRight, true, false);
    drawCorner(cropRect.bottomLeft, false, true);
    drawCorner(cropRect.bottomRight, true, true);
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter oldDelegate) => false;
}
