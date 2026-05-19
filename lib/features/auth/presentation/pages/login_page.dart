import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/l10n_extension.dart';
import '../auth_error_l10n.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/auth_header.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/login_form.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/auth_required_prompt.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.returnTo});

  final String? returnTo;

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<LoginCubit>()) {
      return Scaffold(
        body: Center(child: Text(context.l10n.authModuleDisabled)),
      );
    }

    return BlocProvider<LoginCubit>(
      create: (_) => getIt<LoginCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.loginTitle)),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) async {
                if (state.status == LoginStatus.success) {
                  final router = GoRouter.of(context);
                  final authCubit = context.read<AuthCubit>();
                  await authCubit.checkAuthStatus();
                  router.go(returnTo ?? RouteNames.profile);
                  return;
                }
                if (state.status == LoginStatus.failure) {
                  AppSnackbar.show(
                    context,
                    AuthErrorL10n.messageFor(
                      context,
                      state.errorMessage,
                      fallback: context.l10n.loginFailed,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthHeader(
                      title: context.l10n.loginWelcomeBack,
                      subtitle: context.l10n.loginSubtitle,
                    ),
                    SizedBox(height: 16.h),
                    LoginForm(
                      isLoading: state.status == LoginStatus.loading,
                      onSubmit: (email, password) {
                        context.read<LoginCubit>().login(
                          email: email,
                          password: password,
                        );
                      },
                    ),
                    SizedBox(height: 16.h),
                    SocialLoginButtons(
                      onGooglePressed: () {
                        context.read<AuthCubit>().signInWithGoogle(
                          returnTo: returnTo ?? RouteNames.profile,
                        );
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.push(
                          registerRouteForReturnTo(
                            returnTo ?? RouteNames.profile,
                          ),
                        );
                      },
                      child: Text(context.l10n.loginCreateAccount),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
