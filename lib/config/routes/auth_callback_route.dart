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

  static String failureMessage(Uri _) {
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
