import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/logger_service.dart';
import '../auth_log_redactor.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/user_model.dart';
import 'register_remote_result.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<RegisterRemoteResult> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> resendConfirmation({required String email});
  Future<UserModel?> getCurrentUser();
  Future<void> signInWithGoogle({required String redirectTo});
  Stream<UserModel?> authStateChanges();
  String? getCurrentAccessToken();
  Future<void> logout();
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  SupabaseAuthRemoteDataSource(this._readClient, this._logger, this._dio);

  final SupabaseClient Function() _readClient;
  final LoggerService _logger;
  final Dio _dio;

  static const authCallbackUrl = 'foodify-cooking://login-callback';

  // Kept for backwards compatibility with existing call sites.
  static const googleRedirectUrl = authCallbackUrl;

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    final email = AuthLogRedactor.email(request.email);
    _logger.log('Auth signInWithPassword start email=$email');
    try {
      final response = await _readClient().auth.signInWithPassword(
        email: request.email,
        password: request.password,
      );
      _logger.log(
        'Auth signInWithPassword success email=$email '
        'user=${response.user == null ? 'absent' : 'present'} '
        'session=${response.session == null ? 'absent' : 'present'}',
      );
      return _authResponseFromSupabase(response);
    } on AuthException catch (error) {
      _logger.log(
        'Auth signInWithPassword failure email=$email '
        '${AuthLogRedactor.authException(error)}',
      );
      rethrow;
    } catch (error) {
      _logger.log(
        'Auth signInWithPassword failure email=$email '
        '${AuthLogRedactor.object(error)}',
      );
      rethrow;
    }
  }

  @override
  Future<RegisterRemoteResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final redactedEmail = AuthLogRedactor.email(email);
    _logger.log('Auth signUp start email=$redactedEmail');
    try {
      final response = await _readClient().auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'full_name': name},
        emailRedirectTo: kIsWeb ? null : authCallbackUrl,
      );
      final hasUser = response.user != null;
      final hasSession = response.session != null;
      _logger.log(
        'Auth signUp success email=$redactedEmail '
        'user=${hasUser ? 'present' : 'absent'} '
        'session=${hasSession ? 'present' : 'absent'} '
        'status=${hasSession ? 'signed_in' : 'needs_confirmation'}',
      );
      if (!hasUser) {
        throw const AuthException('Authentication did not return a user.');
      }
      if (!hasSession) {
        return RegisterRemoteNeedsConfirmation(email);
      }
      return RegisterRemoteSignedIn(_authResponseFromSupabase(response));
    } on AuthException catch (error) {
      _logger.log(
        'Auth signUp failure email=$redactedEmail '
        '${AuthLogRedactor.authException(error)}',
      );
      rethrow;
    } catch (error) {
      _logger.log(
        'Auth signUp failure email=$redactedEmail '
        '${AuthLogRedactor.object(error)}',
      );
      rethrow;
    }
  }

  @override
  Future<void> resendConfirmation({required String email}) async {
    final redactedEmail = AuthLogRedactor.email(email);
    _logger.log('Auth resend start type=signup email=$redactedEmail');
    try {
      await _readClient().auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: kIsWeb ? null : authCallbackUrl,
      );
      _logger.log('Auth resend success type=signup email=$redactedEmail');
    } on AuthException catch (error) {
      _logger.log(
        'Auth resend failure type=signup email=$redactedEmail '
        '${AuthLogRedactor.authException(error)}',
      );
      rethrow;
    } catch (error) {
      _logger.log(
        'Auth resend failure type=signup email=$redactedEmail '
        '${AuthLogRedactor.object(error)}',
      );
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _readClient().auth.currentUser;
    return user == null ? null : UserModel.fromSupabaseUser(user);
  }

  @override
  Future<void> signInWithGoogle({required String redirectTo}) async {
    final effectiveRedirectTo = kIsWeb ? null : redirectTo;
    _logger.log(
      'Auth signInWithOAuth start provider=google '
      'redirectTo=${effectiveRedirectTo ?? 'platform-default'}',
    );
    try {
      await _verifyGoogleProvider(redirectTo: effectiveRedirectTo);
      await _readClient().auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: effectiveRedirectTo,
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
      _logger.log('Auth signInWithOAuth returned provider=google');
    } on AuthException catch (error) {
      _logger.log(
        'Auth signInWithOAuth failure provider=google '
        '${AuthLogRedactor.authException(error)}',
      );
      rethrow;
    } catch (error) {
      _logger.log(
        'Auth signInWithOAuth failure provider=google '
        '${AuthLogRedactor.object(error)}',
      );
      rethrow;
    }
  }

  Future<void> _verifyGoogleProvider({required String? redirectTo}) async {
    final response = await _readClient().auth.getOAuthSignInUrl(
      provider: OAuthProvider.google,
      redirectTo: redirectTo,
      queryParams: const {'skip_http_redirect': 'true'},
    );
    _logger.log(
      'Auth signInWithOAuth preflight provider=google '
      'redirectTo=${redirectTo ?? 'platform-default'}',
    );

    final result = await _dio.getUri<dynamic>(
      Uri.parse(response.url),
      options: Options(
        followRedirects: false,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    final statusCode = result.statusCode ?? 0;
    if (statusCode < 400) return;

    final data = result.data;
    final message =
        _jsonValue(data, 'msg') ??
        _jsonValue(data, 'message') ??
        'Google provider preflight failed';
    final code = _jsonValue(data, 'error_code') ?? _jsonValue(data, 'code');
    throw AuthException(message, statusCode: statusCode.toString(), code: code);
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _readClient().auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      _logger.log(
        'Auth onAuthStateChange event=${data.event.name} '
        'user=${user == null ? 'absent' : 'present'}',
      );
      return user == null ? null : UserModel.fromSupabaseUser(user);
    });
  }

  @override
  String? getCurrentAccessToken() {
    return _readClient().auth.currentSession?.accessToken;
  }

  @override
  Future<void> logout() {
    _logger.log('Auth signOut start');
    return _readClient().auth.signOut().then((_) {
      _logger.log('Auth signOut success');
    });
  }

  AuthResponseModel _authResponseFromSupabase(AuthResponse response) {
    final user = response.user;
    if (user == null) {
      throw const AuthException('Authentication did not return a user.');
    }
    final token =
        response.session?.accessToken ?? getCurrentAccessToken() ?? '';
    return AuthResponseModel(
      token: token,
      user: UserModel.fromSupabaseUser(user),
    );
  }

  String? _jsonValue(Object? data, String key) {
    if (data is Map<String, dynamic>) {
      return data[key]?.toString();
    }
    return null;
  }
}
