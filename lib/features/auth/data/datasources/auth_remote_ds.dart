import '../models/user_model.dart';


class AuthRemoteDataSource {
  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API

    if (email == "test@suredone.com" && password == "1234") {
      return UserModel(
        id: "1",
        name: "Jerico",
        email: email,
      );
    }
    return null;
  }
}
