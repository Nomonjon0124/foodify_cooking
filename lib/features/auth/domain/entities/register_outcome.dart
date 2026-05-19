import 'package:equatable/equatable.dart';

import 'user_entity.dart';

sealed class RegisterOutcome extends Equatable {
  const RegisterOutcome();
}

class RegisterSignedIn extends RegisterOutcome {
  const RegisterSignedIn(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class RegisterNeedsConfirmation extends RegisterOutcome {
  const RegisterNeedsConfirmation(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}
