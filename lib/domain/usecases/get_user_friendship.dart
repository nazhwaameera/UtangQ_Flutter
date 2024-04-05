import 'package:utangq_app/data/exception/friendship_404_exception.dart';
import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/friendship.dart';

class GetUserFriendship {
  var repository = UsersRepository();

  Future<Friendship> execute(int userId) async {
    try {
      final result = await repository.getUserFriendship(userId);

      // Check if the result is not null and return it
      if (result != null) {
        print('This is from usecase ${result.userID}, ${result.friendshipID}');
        return result;
      } else {
        throw FriendshipNotFoundException();
      }
    } catch (e) {
      throw e;
    }
  }
}