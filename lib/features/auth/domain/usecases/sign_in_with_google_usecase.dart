import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase
    implements UseCase<Result<void>, SignInWithGoogleParams> {
  SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(SignInWithGoogleParams params) {
    return _repository.signInWithGoogle(redirectTo: params.redirectTo);
  }
}

class SignInWithGoogleParams extends Equatable {
  const SignInWithGoogleParams({required this.redirectTo});

  final String redirectTo;

  @override
  List<Object?> get props => [redirectTo];
}
