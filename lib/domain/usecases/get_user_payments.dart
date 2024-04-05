import 'package:utangq_app/data/exception/payment_404_exception.dart';
import 'package:utangq_app/data/repository/transactions_repository.dart';
import 'package:utangq_app/domain/entities/bill_receipient_desc.dart';

class GetUserPayments {
  var repository = TransactionsRepository();

  Future<List<BillRecipientWithDesc>> execute(int recipientUserId) async {
    try {
      final result = await repository.getUserPayment(recipientUserId);

      // Check if the result is not null and return it
      if (result != null) {
        return result;
      } else {
        throw PaymentNotFoundException(message: 'Payment not found');
      }
    } catch (e) {
      throw e;
    }
  }
}