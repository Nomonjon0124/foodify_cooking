import 'package:flutter/material.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    required this.backgroundColor,
    required this.imagePaths,
    super.key,
  });

  final Color backgroundColor;
  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            for (var i = 0; i < imagePaths.length; i++) ...[
              _PlateImage(path: imagePaths[i]),
              if (i != imagePaths.length - 1) const SizedBox(height: 35),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _PlateImage extends StatelessWidget {
  const _PlateImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(child: Image.asset(path, fit: BoxFit.cover)),
    );
  }
}
