import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/wallet_balance.dart';

class UpdateWalletBalance{
  var repository = UsersRepository();

  Future<bool> execute(WalletBalance entity) async {
    try {
      return await repository.updateWalletBalance(entity); // Return the Future<LoginUser>
    } catch (e) {
      print('Update wallet balance failed: $e');
      throw Exception('Failed to update wallet balance: $e');
    }
  }
}