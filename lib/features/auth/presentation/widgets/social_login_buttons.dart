import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/l10n_extension.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({required this.onGooglePressed, super.key});

  final VoidCallback onGooglePressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        key: const Key('google_sign_in_button'),
        onPressed: onGooglePressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Text(context.l10n.authContinueWithGoogle),
        ),
      ),
    );
  }
}
