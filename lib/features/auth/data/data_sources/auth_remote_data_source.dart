import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<UserModel> getCurrentUser();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    // TODO: Replace fallback with real API contract.
    final response = await _dioClient.post(
      Endpoints.login,
      data: request.toJson(),
    );
    if (response.data is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    }

    return const AuthResponseModel(
      token: 'demo_token',
      user: UserModel(id: '1', email: 'demo@foodify.app', name: 'Demo User'),
    );
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _dioClient.get(Endpoints.profile);
    if (response.data is Map<String, dynamic>) {
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }

    return const UserModel(
      id: '1',
      email: 'demo@foodify.app',
      name: 'Demo User',
    );
  }

  @override
  Future<void> logout() async {
    await _dioClient.post(Endpoints.logout);
  }
}
