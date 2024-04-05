import 'package:utangq_app/data/repository/transactions_repository.dart';
import 'package:utangq_app/domain/entities/bill_receipient_request.dart';

class ConfirmPayment{
  var repository = TransactionsRepository();

  Future<bool> execute(BillRecipientRequest entity) async {
    try{
      return await repository.confirmPayment(entity);
    } catch(e) {
      print('Confirm payment for bill receipient failed: $e');
      throw Exception('Failed to confirm payment bill receipient: $e');
    }
  }
}