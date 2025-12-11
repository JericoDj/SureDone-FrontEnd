import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repo_impl.dart';

class LoginUseCase {
  final AuthRepository repo;

  LoginUseCase(this.repo);

  Future<UserModel?> call(String email, String password) {
    return repo.login(email, password);
  }
}
