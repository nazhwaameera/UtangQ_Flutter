import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/users.dart';

class GetAllUsers{
  var repository = UsersRepository();

  Future<List<Users>> execute() async {
    return repository.getAllUsers();
  }
}