
import '../../data/datasources/auth_remote_ds.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repo_impl.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepoImpl(this.remote);

  @override
  Future<UserModel?> login(String email, String password) {
    return remote.login(email, password);
  }
}
