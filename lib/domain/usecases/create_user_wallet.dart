import 'package:utangq_app/data/repository/users_repository.dart';

class CreateWallet{
  var repository = UsersRepository();

  Future<bool> execute(int userId) async {
    try{
      return await repository.createUserWallet(userId);
    } catch (e) {
      print('Create wallet failed: $e');
      throw Exception('Failed to create wallet: $e');
    }
  }
}