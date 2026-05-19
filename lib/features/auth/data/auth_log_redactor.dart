import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class AuthLogRedactor {
  static String email(String value) {
    final email = value.trim();
    final atIndex = email.indexOf('@');
    if (atIndex <= 0 || atIndex == email.length - 1) return '<invalid-email>';

    final local = email.substring(0, atIndex);
    final domain = email.substring(atIndex + 1);
    final first = local.substring(0, 1);
    return '$first***@$domain';
  }

  static String authException(AuthException error) {
    return [
      'type=${error.runtimeType}',
      'status=${error.statusCode ?? 'none'}',
      'code=${error.code ?? 'none'}',
      'message="${_sanitizeMessage(error.message)}"',
    ].join(' ');
  }

  static String object(Object error) {
    return 'type=${error.runtimeType} message="${_sanitizeMessage('$error')}"';
  }

  static String _sanitizeMessage(String message) {
    return message.replaceAll(RegExp(r'[\r\n]+'), ' ').trim();
  }
}
