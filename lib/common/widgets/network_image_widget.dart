import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    required this.url,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
      errorWidget: (_, _, _) => const Icon(Icons.error_outline),
    );
  }
}
