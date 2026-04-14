import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.token,
    super.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle nested user object from login/register response
    final userData = json.containsKey('user') ? json['user'] as Map<String, dynamic> : json;

    return UserModel(
      id: userData['id'] as int? ?? 0,
      name: userData['name'] as String? ?? userData['username'] as String? ?? '',
      email: userData['email'] as String? ?? '',
      token: json['token'] as String?,
      roles: userData['roles'] is List ? List<String>.from(userData['roles']) : null,
    );
  }
}
