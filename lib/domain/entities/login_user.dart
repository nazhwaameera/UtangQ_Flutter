// login_user.dart

import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class LoginUser extends HiveObject {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String token;

  LoginUser({required this.userId, required this.username, required this.token});

  // Factory method to create LoginUser object from a Map
  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      userId: json['UserID'],
      username: json['Username'],
      token: json['Token'],
    );
  }
}
