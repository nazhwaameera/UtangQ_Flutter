import 'package:utangq_app/data/repository/transactions_repository.dart';
import 'package:utangq_app/domain/entities/bill_receipient_create.dart';

class CreateBillReceipient{
  var repository = TransactionsRepository();

  Future<bool> execute(BillReceipientCreate entity) async {
    try{
      return await repository.createBillReceipient(entity);
    } catch(e) {
      print('Create bill receipient failed: $e');
      throw Exception('Failed to reate bill receipient: $e');
    }
  }
}