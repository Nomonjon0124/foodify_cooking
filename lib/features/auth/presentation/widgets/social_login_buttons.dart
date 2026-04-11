import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // TODO: Add Google sign-in.
            },
            child: const Text('Google'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // TODO: Add Apple sign-in.
            },
            child: const Text('Apple'),
          ),
        ),
      ],
    );
  }
}
