import 'package:flutter/material.dart';

class SplashLoadingDots extends StatefulWidget {
  const SplashLoadingDots({super.key});

  @override
  State<SplashLoadingDots> createState() => _SplashLoadingDotsState();
}

class _SplashLoadingDotsState extends State<SplashLoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _phaseValue(int index) {
    final value = (_controller.value + (index * 0.2)) % 1;
    if (value < 0.5) return 1;
    return 0.4;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 98,
      height: 65,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(3, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 7,
                  right: index == 2 ? 0 : 7,
                ),
                child: Opacity(
                  opacity: _phaseValue(index),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDEE21B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
