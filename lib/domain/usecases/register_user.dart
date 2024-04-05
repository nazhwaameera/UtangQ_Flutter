import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/user_create.dart';

class Register{
  var repository = UsersRepository();

  Future<bool> execute(UserCreate entity) async {
    try{
      return await repository.createUser(entity);
    } catch (e) {
      print('Register failed: $e');
      throw Exception('Failed to register: $e');
    }
  }

}