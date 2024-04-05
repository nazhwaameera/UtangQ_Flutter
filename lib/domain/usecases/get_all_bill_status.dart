import 'package:utangq_app/data/repository/transactions_repository.dart';
import 'package:utangq_app/domain/entities/bill_status.dart';

class GetAllBillStatuses{
  var repository = TransactionsRepository();

  Future<List<BillStatus>> execute() async {
    return repository.getAllBillStatuses();
  }
}