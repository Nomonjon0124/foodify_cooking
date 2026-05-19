import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../l10n/l10n_extension.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({required this.isLoading, required this.onSubmit, super.key});

  final bool isLoading;
  final void Function(String email, String password) onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_emailController.text, _passwordController.text);
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
              return null;
            },
          ),
          SizedBox(height: 16.h),
          AppButton(
            text: l10n.loginTitle,
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
