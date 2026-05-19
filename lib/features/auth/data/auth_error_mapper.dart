import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/auth_failure_messages.dart';

enum AuthOperation { login, register, googleSignIn }

abstract final class AuthErrorMapper {
  static String mapAuthException(
    AuthException error, {
    required AuthOperation operation,
  }) {
    final normalized = '${error.code ?? ''} ${error.message}'.toLowerCase();

    if (_isGoogleProviderDisabled(error, normalized)) {
      return AuthFailureMessages.googleProviderDisabled;
    }
    if (_hasAny(normalized, const [
      'invalid_credentials',
      'invalid login credentials',
      'invalid email or password',
    ])) {
      return AuthFailureMessages.invalidCredentials;
    }
    if (error.code == 'email_not_confirmed' ||
        normalized.contains('email not confirmed') ||
        normalized.contains('confirm your email')) {
      return AuthFailureMessages.emailNotConfirmed;
    }
    if (error.statusCode == '429' ||
        _hasAny(normalized, const [
          'over_request_rate_limit',
          'over_email_send_rate_limit',
          'rate limit',
          'too many requests',
        ])) {
      return AuthFailureMessages.rateLimited;
    }
    if (_hasAny(normalized, const [
      'network',
      'dioexception',
      'socketexception',
      'failed host lookup',
      'connection closed',
      'connection refused',
      'connection reset',
      'request_timeout',
    ])) {
      return AuthFailureMessages.network;
    }

    return switch (operation) {
      AuthOperation.login => AuthFailureMessages.loginFailed,
      AuthOperation.register => AuthFailureMessages.registerFailed,
      AuthOperation.googleSignIn => AuthFailureMessages.googleSignInFailed,
    };
  }

  static String mapUnknown(Object error, {required AuthOperation operation}) {
    final normalized = '$error'.toLowerCase();
    if (_hasAny(normalized, const [
      'network',
      'dioexception',
      'socketexception',
      'failed host lookup',
      'connection refused',
      'connection reset',
      'request_timeout',
    ])) {
      return AuthFailureMessages.network;
    }

    return switch (operation) {
      AuthOperation.login => AuthFailureMessages.loginFailed,
      AuthOperation.register => AuthFailureMessages.registerFailed,
      AuthOperation.googleSignIn => AuthFailureMessages.googleSignInFailed,
    };
  }

  static bool _isGoogleProviderDisabled(
    AuthException error,
    String normalized,
  ) {
    if (error.code == 'provider_disabled' ||
        error.code == 'oauth_provider_not_supported') {
      return true;
    }

    return _hasAny(normalized, const [
      'provider is not enabled',
      'unsupported provider',
      'oauth_provider_not_supported',
    ]);
  }

  static bool _hasAny(String value, List<String> needles) {
    return needles.any(value.contains);
  }
}
