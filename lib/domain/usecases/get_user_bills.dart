import 'package:utangq_app/data/exception/bill_404_exception.dart';
import 'package:utangq_app/data/exception/wallet_404_exception.dart';
import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/bill.dart';
import 'package:utangq_app/domain/entities/wallet.dart';

class GetUserBills {
  var repository = UsersRepository();

  Future<List<Bill>> execute(int userId) async {
    try {
      final result = await repository.getUserBills(userId);

      // Check if the result is not null and return it
      if (result != null) {
        return result;
      } else {
        throw BillNotFoundException(message: 'Bill not found');
      }
    } catch (e) {
      throw e;
    }
  }
}