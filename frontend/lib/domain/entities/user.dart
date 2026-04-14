import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.roles,
  });

  final int id;
  final String name;
  final String email;
  final String? token;
  final List<String>? roles;

  @override
  List<Object?> get props => [id, name, email, token, roles];
}
