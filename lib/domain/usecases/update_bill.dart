import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/bill.dart';

class UpdateBill{
  var repository = UsersRepository();

  Future<bool> execute(Bill entity) async{
    try{
      return await repository.updateBill(entity);
    } catch(e) {
      throw e;
    }
  }
}