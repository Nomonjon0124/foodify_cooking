import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/l10n_extension.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_form.dart';
import '../widgets/social_login_buttons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
              listener: (context, state) {
                if (state.status == LoginStatus.success) {
                  context.push(RouteNames.profile);
                }
                if (state.status == LoginStatus.failure) {
                  AppSnackbar.show(context, context.l10n.loginFailed);
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
                    const SocialLoginButtons(),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.push(RouteNames.register);
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
