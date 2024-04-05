import 'package:hive_flutter/adapters.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:utangq_app/data/repository/users_repository.dart';

Future<String> getTokenFromHive() async {
  try {
    final box = await Hive.openBox(UsersRepository.boxName);
    final loginUser = box.values.first;
    final String token = loginUser.token;
    await box.close();
    return token;
  } catch (e) {
    throw Exception('Error retrieving token from Hive: $e');
  }
}
Future<int> getUserIdFromHive() async {
  try {
    final box = await Hive.openBox(UsersRepository.boxName);
    final loginUser = box.values.first;
    final int userId = loginUser.userId;
    await box.close();
    return userId;
  } catch (e) {
    throw Exception('Error retrieving user Id from Hive: $e');
  }
}
bool isExpired(String token) {
  bool hasExpired = JwtDecoder.isExpired(token);
  return hasExpired;
}

Future<bool> isHiveBoxEmpty() async {
  final box = await Hive.openBox(UsersRepository.boxName);
  final isEmpty = box.isEmpty;
  return isEmpty;
}