import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/friendship_status.dart';

class GetAllFriendshipStatus{
  var repository = UsersRepository();

  Future<List<FriendshipStatus>> execute() async {
    return repository.getAllFriendshipStatus();
  }
}