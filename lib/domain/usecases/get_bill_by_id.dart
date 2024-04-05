import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/bill.dart';

class GetBillById{
  var repository = UsersRepository();

  Future<Bill> execute(int billId) async{
    return repository.getBillbyId(billId);
  }
}