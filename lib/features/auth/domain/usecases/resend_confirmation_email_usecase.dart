import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class ResendConfirmationEmailUseCase
    implements UseCase<Result<void>, ResendConfirmationEmailParams> {
  ResendConfirmationEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(ResendConfirmationEmailParams params) {
    return _repository.resendConfirmation(email: params.email);
  }
}

class ResendConfirmationEmailParams extends Equatable {
  const ResendConfirmationEmailParams({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
