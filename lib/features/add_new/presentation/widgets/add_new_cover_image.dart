import 'dart:typed_data';

import 'package:flutter/material.dart';

class AddNewCoverImage extends StatelessWidget {
  const AddNewCoverImage({
    required this.source,
    super.key,
    this.bytes,
    this.width,
    this.height,
    this.fit,
  });

  final String source;
  final Uint8List? bytes;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final imageBytes = bytes;
    if (imageBytes != null) {
      return Image.memory(
        imageBytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _fallback(width, height),
      );
    }

    if (source.startsWith('http://') ||
        source.startsWith('https://') ||
        source.startsWith('blob:')) {
      return Image.network(
        source,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _fallback(width, height),
      );
    }

    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => _fallback(width, height),
    );
  }

  Widget _fallback(double? width, double? height) {
    return SizedBox(
      width: width,
      height: height,
      child: const ColoredBox(
        color: Color(0xFFEAEAEA),
        child: Icon(Icons.image_not_supported_outlined),
      ),
    );
  }
}
