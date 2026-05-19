import 'package:flutter/widgets.dart';

import '../../../l10n/l10n_extension.dart';
import '../domain/auth_failure_messages.dart';

abstract final class AuthErrorL10n {
  static String messageFor(
    BuildContext context,
    String? message, {
    required String fallback,
  }) {
    final value = message?.trim();
    if (value == null || value.isEmpty) return fallback;

    final l10n = context.l10n;
    return switch (value) {
      AuthFailureMessages.googleProviderDisabled =>
        l10n.authGoogleProviderDisabled,
      AuthFailureMessages.invalidCredentials => l10n.authInvalidCredentials,
      AuthFailureMessages.emailNotConfirmed => l10n.authEmailNotConfirmed,
      AuthFailureMessages.emailConfirmationFailed =>
        l10n.authEmailConfirmationFailed,
      AuthFailureMessages.resendRateLimited => l10n.authResendRateLimited,
      AuthFailureMessages.resendUserAlreadyConfirmed =>
        l10n.authResendUserAlreadyConfirmed,
      AuthFailureMessages.resendFailed => l10n.authResendFailed,
      AuthFailureMessages.rateLimited => l10n.authRateLimited,
      AuthFailureMessages.network => l10n.authNetworkFailure,
      AuthFailureMessages.loginFailed => l10n.loginFailed,
      AuthFailureMessages.registerFailed => l10n.registerFailed,
      AuthFailureMessages.googleSignInFailed => l10n.authGoogleSignInFailed,
      AuthFailureMessages.googleCallbackFailed => l10n.authGoogleCallbackFailed,
      _ => value,
    };
  }
}
