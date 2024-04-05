import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/users.dart';

class GetUserNonFriends {
  var repository = UsersRepository();

  Future<List<Users>> execute(int friendshipId) async {
    return repository.getUserNonFriends(friendshipId);
  }
}