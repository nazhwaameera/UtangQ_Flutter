import 'package:utangq_app/data/exception/friendship_list_404_exception.dart';
import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/friendship_list.dart';

class GetFriendshipListByUserId{
  var repository = UsersRepository();

  Future<List<FriendshipList>> execute(int userId) async {
    var result = await repository.getFriendshipListByUserId(userId);
    if(result != null){
      return result;
    } else {
      throw FriendshipListNotFoundException();
    }
  }
}