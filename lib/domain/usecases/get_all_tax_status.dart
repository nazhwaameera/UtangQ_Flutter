import 'package:utangq_app/data/repository/transactions_repository.dart';
import 'package:utangq_app/domain/entities/tax_status.dart';

class GetAllTaxStatuses{
  var repository = TransactionsRepository();

  Future<List<TaxStatus>> execute() async {
    return repository.getAllTaxStatuses();
  }
}