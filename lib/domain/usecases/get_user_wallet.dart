import 'package:utangq_app/data/exception/wallet_404_exception.dart';
import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/wallet.dart';

class GetUserWallet {
  var repository = UsersRepository();

  Future<Wallet> execute(int userId) async {
    try {
      final result = await repository.readUserWallet(userId);

      // Check if the result is not null and return it
      if (result != null) {
        return result;
      } else {
        throw WalletNotFoundException();
      }
    } catch (e) {
      throw e;
    }
  }
}