import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/login_user.dart';

class Login{
  var repository = UsersRepository();

  Future<LoginUser> execute(String usernameLogin, String passwordLogin) async {
    try {
      return await repository.loginUser(usernameLogin, passwordLogin); // Return the Future<LoginUser>
    } catch (e) {
      print('Login failed: $e');
      throw Exception('Failed to login: $e');
    }
  }
}