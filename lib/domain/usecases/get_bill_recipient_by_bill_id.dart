import 'package:utangq_app/data/repository/transactions_repository.dart';
import 'package:utangq_app/domain/entities/bill_recipient.dart';

class GetBillRecipientByBillId{
  var repository = TransactionsRepository();

  Future<List<BillRecipient>> execute(int billId) async{
    return repository.getBillRecipientbyBillId(billId);
  }
}