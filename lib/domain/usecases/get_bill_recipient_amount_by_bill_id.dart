import 'package:utangq_app/data/repository/transactions_repository.dart';

class GetBillRecipientAmountbyBillId{
  var repository = TransactionsRepository();

  Future<double> execute(int billId) async{
    return repository.getBillRecipientAmountbyBillId(billId);
  }
}