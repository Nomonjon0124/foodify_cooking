import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CropPhotoView extends StatelessWidget {
  const CropPhotoView({required this.imagePath, super.key});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, stack) => Container(
            color: const Color(0xFF1A1A1A),
            child: Icon(
              Icons.image_outlined,
              color: const Color(0xFF717171),
              size: 64.r,
            ),
          ),
        ),
        // Dark overlay outside crop frame
        CustomPaint(painter: _CropOverlayPainter()),
        // Rotate icon at bottom center
        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.rotate_right, color: Colors.white, size: 24.r),
            ),
          ),
        ),
      ],
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.5);

    // Crop rect: centered, 296w x 320h
    const cropWidth = 296.0;
    const cropHeight = 320.0;
    final left = (size.width - cropWidth) / 2;
    final top = (size.height - cropHeight) / 2;
    final cropRect = Rect.fromLTWH(left, top, cropWidth, cropHeight);

    // Draw dark overlay around crop area
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()
      ..addRect(fullRect)
      ..addRect(cropRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    // Draw white crop border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(cropRect, borderPaint);

    // Draw grid lines (3x3)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 0.8;

    final colW = cropWidth / 3;
    final rowH = cropHeight / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(left + colW * i, top),
        Offset(left + colW * i, top + cropHeight),
        gridPaint,
      );
      canvas.drawLine(
        Offset(left, top + rowH * i),
        Offset(left + cropWidth, top + rowH * i),
        gridPaint,
      );
    }

    // Draw corner handles
    const handleLen = 20.0;
    const handleWidth = 3.0;
    final cornerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = handleWidth
      ..strokeCap = StrokeCap.square;

    // Top-left
    canvas.drawLine(
      Offset(left, top),
      Offset(left + handleLen, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + handleLen),
      cornerPaint,
    );
    // Top-right
    canvas.drawLine(
      Offset(left + cropWidth, top),
      Offset(left + cropWidth - handleLen, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + cropWidth, top),
      Offset(left + cropWidth, top + handleLen),
      cornerPaint,
    );
    // Bottom-left
    canvas.drawLine(
      Offset(left, top + cropHeight),
      Offset(left + handleLen, top + cropHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + cropHeight),
      Offset(left, top + cropHeight - handleLen),
      cornerPaint,
    );
    // Bottom-right
    canvas.drawLine(
      Offset(left + cropWidth, top + cropHeight),
      Offset(left + cropWidth - handleLen, top + cropHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + cropWidth, top + cropHeight),
      Offset(left + cropWidth, top + cropHeight - handleLen),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
