// lib/models/user_model.dart
class UserModel {
  final String username;
  final String password;
  final bool isAdmin;

  UserModel(
      {required this.username, required this.password, this.isAdmin = false});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      password: json['password'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'isAdmin': isAdmin,
    };
  }
}
