import '../../domain/entities/profile_view.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ProfileView> getDemoProfile() {
    return _remoteDataSource.getProfileBySlug('mark-salvador');
  }
}
