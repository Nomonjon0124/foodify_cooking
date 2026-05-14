import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FoodifyImage extends StatelessWidget {
  const FoodifyImage(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit,
  });

  final String source;
  final double? width;
  final double? height;
  final BoxFit? fit;

  bool get _isNetworkSource =>
      source.startsWith('https://') || source.startsWith('http://');

  @override
  Widget build(BuildContext context) {
    if (source.isEmpty) {
      return const ColoredBox(
        color: Color(0xFFEAEAEA),
        child: Icon(Icons.image_not_supported_outlined),
      );
    }

    if (_isNetworkSource) {
      return CachedNetworkImage(
        imageUrl: source,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => const ColoredBox(color: Color(0xFFEAEAEA)),
        errorWidget: (_, _, _) => const ColoredBox(
          color: Color(0xFFEAEAEA),
          child: Icon(Icons.image_not_supported_outlined),
        ),
      );
    }

    return Image.asset(source, width: width, height: height, fit: fit);
  }
}
