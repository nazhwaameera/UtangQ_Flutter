import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/friend_request.dart';

class CreateFriendRequest{
  var repository = UsersRepository();

  Future<bool> execute(FriendRequest entity) async {
    try{
      return await repository.createFriendRequest(entity);
    } catch (e) {
      print('Create friend request failed: $e');
      throw Exception('Failed to create friend request: $e');
    }
  }
}