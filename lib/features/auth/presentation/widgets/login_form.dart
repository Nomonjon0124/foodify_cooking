import 'package:flutter/material.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({required this.isLoading, required this.onSubmit, super.key});

  final bool isLoading;
  final void Function(String email, String password) onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@foodify.app');
  final _passwordController = TextEditingController(text: '123456');

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final requiredError = Validators.requiredField(
                value,
                fieldName: 'Email',
              );
              if (requiredError != null) return requiredError;
              final email = value ?? '';
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                return 'Invalid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            obscureText: true,
            validator: (value) =>
                Validators.requiredField(value, fieldName: 'Password'),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Login',
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
