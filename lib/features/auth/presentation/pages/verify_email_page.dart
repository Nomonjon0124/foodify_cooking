import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/widgets/foodify_components/foodify_button.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/l10n_extension.dart';
import '../auth_error_l10n.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../cubit/verify_email_cubit.dart';
import '../cubit/verify_email_state.dart';
import '../widgets/auth_header.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key, required this.email, this.returnTo});

  final String email;
  final String? returnTo;

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<VerifyEmailCubit>()) {
      return Scaffold(
        body: Center(child: Text(context.l10n.authModuleDisabled)),
      );
    }

    return BlocProvider<VerifyEmailCubit>(
      create: (_) => getIt<VerifyEmailCubit>(),
      child: _VerifyEmailView(email: email, returnTo: returnTo),
    );
  }
}

class _VerifyEmailView extends StatelessWidget {
  const _VerifyEmailView({required this.email, required this.returnTo});

  final String email;
  final String? returnTo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.isAuthenticated != current.isAuthenticated,
          listener: (context, state) {
            if (state.isAuthenticated) {
              context.go(returnTo ?? RouteNames.home);
            }
          },
        ),
        BlocListener<VerifyEmailCubit, VerifyEmailState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == VerifyEmailStatus.success) {
              AppSnackbar.show(context, l10n.verifyEmailResendSuccess);
            } else if (state.status == VerifyEmailStatus.failure) {
              AppSnackbar.show(
                context,
                AuthErrorL10n.messageFor(
                  context,
                  state.errorMessage,
                  fallback: l10n.verifyEmailResendFailed,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.verifyEmailTitle)),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
            child: BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
              builder: (context, state) {
                final isLoading = state.status == VerifyEmailStatus.loading;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeader(
                      title: l10n.verifyEmailHeading,
                      subtitle: l10n.verifyEmailSubtitle(email),
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: FoodifyButton(
                        text: l10n.verifyEmailResendCta,
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () => context.read<VerifyEmailCubit>().resend(
                                email: email,
                              ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Center(
                      child: TextButton(
                        onPressed: () => _openMailApp(context),
                        child: Text(l10n.verifyEmailOpenMailApp),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(RouteNames.login),
                        child: Text(l10n.verifyEmailBackToLogin),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openMailApp(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final fallback = context.l10n.verifyEmailOpenMailAppFailed;
    final uri = Uri.parse('mailto:');
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    ).catchError((_) => false);
    if (!launched) {
      messenger.showSnackBar(SnackBar(content: Text(fallback)));
    }
  }
}
