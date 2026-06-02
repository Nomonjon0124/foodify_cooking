import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';

class CropPhotoView extends StatelessWidget {
  const CropPhotoView({
    required this.imagePath,
    this.imageBytes,
    required this.quarterTurns,
    required this.onCancel,
    required this.onDone,
    required this.onRotate,
    super.key,
  });

  final String imagePath;
  final Uint8List? imageBytes;
  final int quarterTurns;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final VoidCallback onRotate;

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);

    return ColoredBox(
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final topReserved = safePadding.top + 76.h;
          final bottomReserved = safePadding.bottom + 104.h;

          return Stack(
            fit: StackFit.expand,
            children: [
              RotatedBox(
                quarterTurns: quarterTurns,
                child: imageBytes == null
                    ? Image.asset(imagePath, fit: BoxFit.cover)
                    : Image.memory(imageBytes!, fit: BoxFit.cover),
              ),
              CustomPaint(
                painter: _CropOverlayPainter(
                  topReserved: topReserved,
                  bottomReserved: bottomReserved,
                ),
              ),
              Positioned(
                top: safePadding.top + 12.h,
                left: 16.w,
                right: 16.w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.48),
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      children: [
                        _CropToolbarButton(
                          key: const Key('crop-cancel-button'),
                          label: context.l10n.addNewCropCancel,
                          onTap: onCancel,
                        ),
                        const Spacer(),
                        _CropToolbarButton(
                          key: const Key('crop-done-button'),
                          label: context.l10n.addNewCropDone,
                          onTap: onDone,
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: safePadding.bottom + 24.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Tooltip(
                    message: context.l10n.addNewCropRotate,
                    child: Semantics(
                      button: true,
                      label: context.l10n.addNewCropRotate,
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.58),
                        shape: const CircleBorder(),
                        child: InkWell(
                          key: const Key('crop-rotate-button'),
                          customBorder: const CircleBorder(),
                          onTap: onRotate,
                          child: SizedBox(
                            width: 48.r,
                            height: 48.r,
                            child: Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                              size: 24.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CropToolbarButton extends StatelessWidget {
  const _CropToolbarButton({
    required this.label,
    required this.onTap,
    super.key,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: Size(88.w, 40.r),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        foregroundColor: isPrimary ? const Color(0xFF0E0E0E) : Colors.white,
        backgroundColor: isPrimary
            ? const Color(0xFFDEE21B)
            : Colors.white.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          fontFamily: FontFamily.montserrat,
        ),
      ),
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  const _CropOverlayPainter({
    required this.topReserved,
    required this.bottomReserved,
  });

  final double topReserved;
  final double bottomReserved;

  @override
  void paint(Canvas canvas, Size size) {
    final availableHeight = math.max(
      120.0,
      size.height - topReserved - bottomReserved,
    );
    final cropWidth = math.min(size.width - 50, 310.w);
    final cropHeight = math.min(210.h, availableHeight);
    final cropLeft = (size.width - cropWidth) / 2;
    final cropTop = topReserved + ((availableHeight - cropHeight) / 2);
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
  bool shouldRepaint(covariant _CropOverlayPainter oldDelegate) {
    return topReserved != oldDelegate.topReserved ||
        bottomReserved != oldDelegate.bottomReserved;
  }
}
