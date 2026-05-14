import 'package:flutter/material.dart';

class BottomPanelPainter extends CustomPainter {
  const BottomPanelPainter();

  static const _color = Color(0xFF0E0E0E);
  static const _figmaPanelWidth = 312.0;
  static const _figmaPanelHeight = 156.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final scaleX = size.width / _figmaPanelWidth;
    final scaleY = size.height / _figmaPanelHeight;
    Offset p(double x, double y) => Offset(x * scaleX, y * scaleY);

    final path = Path()
      ..moveTo(p(312, 146).dx, p(312, 146).dy)
      ..cubicTo(
        p(312, 151.523).dx,
        p(312, 151.523).dy,
        p(307.523, 156).dx,
        p(307.523, 156).dy,
        p(302, 156).dx,
        p(302, 156).dy,
      )
      ..lineTo(p(201.403, 156).dx, p(201.403, 156).dy)
      ..cubicTo(
        p(196.865, 156).dx,
        p(196.865, 156).dy,
        p(193.014, 152.872).dx,
        p(193.014, 152.872).dy,
        p(191.01, 148.801).dx,
        p(191.01, 148.801).dy,
      )
      ..cubicTo(
        p(184.655, 135.887).dx,
        p(184.655, 135.887).dy,
        p(171.366, 127).dx,
        p(171.366, 127).dy,
        p(156, 127).dx,
        p(156, 127).dy,
      )
      ..cubicTo(
        p(140.634, 127).dx,
        p(140.634, 127).dy,
        p(127.345, 135.887).dx,
        p(127.345, 135.887).dy,
        p(120.99, 148.801).dx,
        p(120.99, 148.801).dy,
      )
      ..cubicTo(
        p(118.986, 152.872).dx,
        p(118.986, 152.872).dy,
        p(115.135, 156).dx,
        p(115.135, 156).dy,
        p(110.597, 156).dx,
        p(110.597, 156).dy,
      )
      ..lineTo(p(10, 156).dx, p(10, 156).dy)
      ..cubicTo(
        p(4.477, 156).dx,
        p(4.477, 156).dy,
        p(0, 151.523).dx,
        p(0, 151.523).dy,
        p(0, 146).dx,
        p(0, 146).dy,
      )
      ..lineTo(p(0, 10).dx, p(0, 10).dy)
      ..cubicTo(
        p(0, 4.477).dx,
        p(0, 4.477).dy,
        p(4.477, 0).dx,
        p(4.477, 0).dy,
        p(10, 0).dx,
        p(10, 0).dy,
      )
      ..lineTo(p(302, 0).dx, p(302, 0).dy)
      ..cubicTo(
        p(307.523, 0).dx,
        p(307.523, 0).dy,
        p(312, 4.477).dx,
        p(312, 4.477).dy,
        p(312, 10).dx,
        p(312, 10).dy,
      )
      ..lineTo(p(312, 146).dx, p(312, 146).dy)
      ..close();

    canvas.drawPath(path, Paint()..color = _color);
  }

  @override
  bool shouldRepaint(covariant BottomPanelPainter oldDelegate) => false;
}
