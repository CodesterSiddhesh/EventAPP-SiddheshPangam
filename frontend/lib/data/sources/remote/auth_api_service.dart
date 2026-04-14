import '../../../core/network/api_client.dart';
import '../../models/user_model.dart';

class AuthApiService {
  AuthApiService({required this.apiClient});

  final ApiClient apiClient;

  Future<UserModel> login({required String email, required String password}) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return UserModel.fromJson(response.data ?? {});
    } catch (e) {
      print('Login API error: $e');
      rethrow;
    }
  }

  Future<UserModel> register({required String name, required String email, required String password}) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        '/api/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      return UserModel.fromJson(response.data ?? {});
    } catch (e) {
      print('Register API error: $e');
      rethrow;
    }
  }
}
