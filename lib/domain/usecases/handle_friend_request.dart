import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/handle_friend_request.dart';

class HandleFriendRequestUC{
  var repository = UsersRepository();

  Future<bool> execute(HandleFriendRequest entity) async {
    try{
      return await repository.handleFriendRequest(entity);
    } catch(e) {
      print('Handle friend request failed: $e');
      throw Exception('Failed to handle friend request: $e');
    }
  }
}