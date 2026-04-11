import 'package:flutter/material.dart';

class OnboardingCtaButton extends StatelessWidget {
  const OnboardingCtaButton({
    required this.isLastPage,
    required this.progress,
    required this.onPressed,
    required this.backgroundColor,
    super.key,
  });

  final bool isLastPage;
  final double progress;
  final VoidCallback onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 78,
        height: 78,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 68,
              height: 68,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
                backgroundColor: Colors.white.withValues(alpha: 0.45),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: isLastPage ? const Color(0xFFF2F2F2) : backgroundColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isLastPage
                  ? const Text(
                      'Go',
                      style: TextStyle(
                        color: Color(0xFF0E0E0E),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
