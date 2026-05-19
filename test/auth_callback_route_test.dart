import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/config/routes/auth_callback_route.dart';
import 'package:foodify_cooking/config/routes/route_names.dart';
import 'package:foodify_cooking/features/auth/domain/auth_failure_messages.dart';

void main() {
  group('AuthCallbackRoute', () {
    test('matches the Supabase Android deep link callback', () {
      final uri = Uri.parse(
        'foodify-cooking://login-callback/?code=oauth-code',
      );

      expect(AuthCallbackRoute.matches(uri), isTrue);
      expect(AuthCallbackRoute.hasFailure(uri), isFalse);
      expect(AuthCallbackRoute.redirectLocation(uri), RouteNames.home);
    });

    test('maps callback query failures to Google callback failure', () {
      final uri = Uri.parse(
        'foodify-cooking://login-callback/?'
        'error=server_error&'
        'error_code=unexpected_failure&'
        'error_description=Unable+to+exchange+external+code%3A+4%2FOA',
      );

      expect(AuthCallbackRoute.matches(uri), isTrue);
      expect(AuthCallbackRoute.hasFailure(uri), isTrue);
      expect(
        AuthCallbackRoute.failureMessage(uri),
        AuthFailureMessages.googleCallbackFailed,
      );
    });

    test('maps callback fragment failures to Google callback failure', () {
      final uri = Uri.parse(
        'foodify-cooking://login-callback/#'
        'error=server_error&'
        'error_code=unexpected_failure&'
        'error_description=Unable+to+exchange+external+code%3A+4%2FOA',
      );

      expect(AuthCallbackRoute.hasFailure(uri), isTrue);
      expect(
        AuthCallbackRoute.failureMessage(uri),
        AuthFailureMessages.googleCallbackFailed,
      );
    });
  });
}
