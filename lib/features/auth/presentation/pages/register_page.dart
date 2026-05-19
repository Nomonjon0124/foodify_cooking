import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/l10n_extension.dart';
import '../auth_error_l10n.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_required_prompt.dart';
import '../widgets/social_login_buttons.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, this.returnTo});

  final String? returnTo;

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<RegisterCubit>()) {
      return Scaffold(
        body: Center(child: Text(context.l10n.authModuleDisabled)),
      );
    }

    return BlocProvider<RegisterCubit>(
      create: (_) => getIt<RegisterCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.registerTitle)),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) async {
                if (state.status == RegisterStatus.success) {
                  final router = GoRouter.of(context);
                  final authCubit = context.read<AuthCubit>();
                  await authCubit.checkAuthStatus();
                  router.go(returnTo ?? RouteNames.profile);
                  return;
                }
                if (state.status == RegisterStatus.confirmationRequired) {
                  AppSnackbar.show(
                    context,
                    context.l10n.registerConfirmationRequired,
                  );
                }
                if (state.status == RegisterStatus.failure) {
                  AppSnackbar.show(
                    context,
                    AuthErrorL10n.messageFor(
                      context,
                      state.errorMessage,
                      fallback: context.l10n.registerFailed,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return ListView(
                  children: [
                    AuthHeader(
                      title: context.l10n.registerWelcome,
                      subtitle: context.l10n.registerSubtitle,
                    ),
                    SizedBox(height: 16.h),
                    _RegisterForm(
                      isLoading: state.status == RegisterStatus.loading,
                      onSubmit: (name, email, password) {
                        context.read<RegisterCubit>().register(
                          name: name,
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
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: () {
                        context.push(
                          loginRouteForReturnTo(returnTo ?? RouteNames.profile),
                        );
                      },
                      child: Text(context.l10n.registerAlreadyHaveAccount),
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

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({required this.isLoading, required this.onSubmit});

  final bool isLoading;
  final void Function(String name, String email, String password) onSubmit;

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: _nameController,
            label: l10n.registerName,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.fieldRequired(l10n.registerName);
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          AppTextField(
            controller: _emailController,
            label: l10n.loginEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.fieldRequired(l10n.loginEmail);
              }
              final email = value.trim();
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                return l10n.invalidEmail;
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          AppTextField(
            controller: _passwordController,
            label: l10n.loginPassword,
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.fieldRequired(l10n.loginPassword);
              }
              if (value.trim().length < 6) {
                return l10n.registerPasswordMinLength;
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          AppButton(
            text: l10n.registerTitle,
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
