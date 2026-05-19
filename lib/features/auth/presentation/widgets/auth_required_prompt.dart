import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';
import '../cubit/auth_cubit.dart';

Future<void> showAuthRequiredSheet(
  BuildContext context, {
  required String returnTo,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (sheetContext) {
      return AuthRequiredPrompt(
        onEmailPressed: () {
          Navigator.of(sheetContext).pop();
          context.push(_loginRoute(returnTo));
        },
        onGooglePressed: () {
          Navigator.of(sheetContext).pop();
          context.read<AuthCubit>().signInWithGoogle(returnTo: returnTo);
        },
      );
    },
  );
}

class AuthRequiredPrompt extends StatelessWidget {
  const AuthRequiredPrompt({
    required this.onGooglePressed,
    required this.onEmailPressed,
    super.key,
  });

  final VoidCallback onGooglePressed;
  final VoidCallback onEmailPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.authRequiredTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF0E0E0E),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                l10n.authRequiredSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF717171),
                  fontSize: 14.sp,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
              SizedBox(height: 20.h),
              OutlinedButton(
                key: const Key('auth_required_google_button'),
                onPressed: onGooglePressed,
                child: Text(l10n.authContinueWithGoogle),
              ),
              SizedBox(height: 10.h),
              OutlinedButton(
                key: const Key('auth_required_email_button'),
                onPressed: onEmailPressed,
                child: Text(l10n.authContinueWithEmail),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String loginRouteForReturnTo(String returnTo) => _loginRoute(returnTo);

String registerRouteForReturnTo(String returnTo) {
  return Uri(
    path: RouteNames.register,
    queryParameters: {'returnTo': returnTo},
  ).toString();
}

String _loginRoute(String returnTo) {
  return Uri(
    path: RouteNames.login,
    queryParameters: {'returnTo': returnTo},
  ).toString();
}
