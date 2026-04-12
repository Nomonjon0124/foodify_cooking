import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
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
      return const Scaffold(
        body: Center(child: Text('Auth module is disabled')),
      );
    }

    return BlocProvider<LoginCubit>(
      create: (_) => getIt<LoginCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state.status == LoginStatus.success) {
                  context.push(RouteNames.profile);
                }
                if (state.status == LoginStatus.failure) {
                  AppSnackbar.show(
                    context,
                    state.errorMessage ?? 'Login failed',
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(
                      title: 'Welcome back',
                      subtitle: 'Login to continue cooking',
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
                      child: const Text('Create account'),
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
