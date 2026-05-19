import '../models/auth_response_model.dart';

sealed class RegisterRemoteResult {
  const RegisterRemoteResult();
}

class RegisterRemoteSignedIn extends RegisterRemoteResult {
  const RegisterRemoteSignedIn(this.response);

  final AuthResponseModel response;
}

class RegisterRemoteNeedsConfirmation extends RegisterRemoteResult {
  const RegisterRemoteNeedsConfirmation(this.email);

  final String email;
}
