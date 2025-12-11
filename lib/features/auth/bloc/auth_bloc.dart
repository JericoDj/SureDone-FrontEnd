import 'package:flutter_bloc/flutter_bloc.dart';


import '../data/datasources/auth_remote_ds.dart' show AuthRemoteDataSource;
import '../data/repositories/auth_repo_impl.dart';
import '../domain/repositories/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc()
      : repo = AuthRepoImpl(AuthRemoteDataSource()),
        super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final user = await repo.login(event.email, event.password);

    if (user == null) {
      emit(AuthError("Invalid email or password"));
    } else {
      emit(AuthSuccess(user));
    }
  }
}
