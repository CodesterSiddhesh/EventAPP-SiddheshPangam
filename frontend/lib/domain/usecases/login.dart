import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  Login(this.repository);

  final AuthRepository repository;

  Future<User> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
