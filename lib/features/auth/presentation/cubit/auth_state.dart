import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, failure }

const _unset = Object();

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.pendingRoute,
  });

  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? pendingRoute;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  AuthState copyWith({
    AuthStatus? status,
    Object? user = _unset,
    Object? errorMessage = _unset,
    Object? pendingRoute = _unset,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: identical(user, _unset) ? this.user : user as UserEntity?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      pendingRoute: identical(pendingRoute, _unset)
          ? this.pendingRoute
          : pendingRoute as String?,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, pendingRoute];
}
