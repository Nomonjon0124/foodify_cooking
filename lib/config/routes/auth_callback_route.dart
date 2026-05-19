import '../../features/auth/domain/auth_failure_messages.dart';
import 'route_names.dart';

abstract final class AuthCallbackRoute {
  static const _scheme = 'foodify-cooking';
  static const _host = 'login-callback';

  static bool matches(Uri uri) {
    return uri.scheme == _scheme && uri.host == _host;
  }

  static bool hasFailure(Uri uri) {
    return _parameter(uri, 'error') != null ||
        _parameter(uri, 'error_code') != null ||
        _parameter(uri, 'error_description') != null;
  }

  /// Detects whether the callback represents an email confirmation. Supabase
  /// uses the `type=signup` (PKCE flow query param) or the fragment-style
  /// `#type=signup&...` hash flow. Both are surfaced here.
  static bool isEmailConfirmation(Uri uri) {
    final type = _parameter(uri, 'type');
    return type == 'signup' || type == 'email_change';
  }

  static String failureMessage(Uri uri) {
    if (isEmailConfirmation(uri)) {
      return AuthFailureMessages.emailConfirmationFailed;
    }
    return AuthFailureMessages.googleCallbackFailed;
  }

  static String redirectLocation(Uri _) {
    return RouteNames.home;
  }

  static String? _parameter(Uri uri, String key) {
    final queryValue = uri.queryParameters[key];
    if (queryValue != null && queryValue.trim().isNotEmpty) {
      return queryValue;
    }

    final fragment = uri.fragment;
    if (fragment.isEmpty) return null;

    final fragmentValue = Uri.splitQueryString(fragment)[key];
    if (fragmentValue == null || fragmentValue.trim().isEmpty) return null;
    return fragmentValue;
  }
}
