import '../entities/profile_view.dart';

abstract interface class ProfileRepository {
  Future<ProfileView> getDemoProfile();
  Future<ProfileView> getCurrentProfile();
}
