import '../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/remote/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authApiService});

  final AuthApiService authApiService;

  @override
  Future<User> login({required String email, required String password}) async {
    final user = await authApiService.login(email: email, password: password);

    // Save token and user data
    if (user.token != null) {
      await TokenStorage.saveToken(user.token!);
      await TokenStorage.saveUserData(user.id, user.name, user.email);
    }

    return user;
  }

  @override
  Future<User> register({required String name, required String email, required String password}) async {
    final user = await authApiService.register(name: name, email: email, password: password);

    // Save token and user data
    if (user.token != null) {
      await TokenStorage.saveToken(user.token!);
      await TokenStorage.saveUserData(user.id, user.name, user.email);
    }

    return user;
  }
}
