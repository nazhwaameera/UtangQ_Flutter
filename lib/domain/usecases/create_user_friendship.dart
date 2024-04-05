import 'package:utangq_app/data/repository/users_repository.dart';

class CreateUserFriendship{
  var repository = UsersRepository();

  Future<bool> execute(int userId) async {
    try{
      print('Entering use case create friendship.');
      return await repository.createUserFriendship(userId);
    } catch (e) {
      print('Create friendship failed: $e');
      throw Exception('Failed to create friendship: $e');
    }
  }
}