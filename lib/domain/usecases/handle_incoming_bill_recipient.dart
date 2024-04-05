import 'package:utangq_app/data/repository/transactions_repository.dart';
import 'package:utangq_app/domain/entities/bill_receipient_request.dart';

class HandleIncomingBillRecipient{
  var repository = TransactionsRepository();

  Future<bool> execute(BillRecipientRequest entity) async {
    try{
      return await repository.handleIncomingBillReceipient(entity);
    } catch(e) {
      print('Handle bill receipient failed: $e');
      throw Exception('Failed to handle bill receipient: $e');
    }
  }
}