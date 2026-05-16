import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingCtaButton extends StatefulWidget {
  const OnboardingCtaButton({
    required this.isLastPage,
    required this.label,
    required this.progress,
    required this.onPressed,
    required this.backgroundColor,
    super.key,
  });

  final bool isLastPage;
  final String label;
  final double progress;
  final VoidCallback onPressed;
  final Color backgroundColor;

  @override
  State<OnboardingCtaButton> createState() => _OnboardingCtaButtonState();
}

class _OnboardingCtaButtonState extends State<OnboardingCtaButton> {
  var _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onPressed,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: 78.r,
          height: 78.r,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 68.r,
                height: 68.r,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: widget.progress),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutCubic,
                  builder: (context, value, child) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 3.r,
                      backgroundColor: Colors.white.withValues(alpha: 0.45),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    );
                  },
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                width: 58.r,
                height: 58.r,
                decoration: BoxDecoration(
                  color: widget.isLastPage
                      ? const Color(0xFFF2F2F2)
                      : widget.backgroundColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: widget.isLastPage
                      ? Text(
                          widget.label,
                          key: const ValueKey<String>('go_label'),
                          style: TextStyle(
                            color: Color(0xFF0E0E0E),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Montserrat',
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey<String>('empty')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
