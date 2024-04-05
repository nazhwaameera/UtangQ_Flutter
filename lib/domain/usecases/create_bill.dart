import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/bill_create.dart';

class CreateBill{
  var repository = UsersRepository();
  Future<bool> execute(BillCreate entity) async {
    try{
      return await repository.createBill(entity);
    } catch (e) {
      print('Create bill failed: $e');
      throw e;
    }
  }
}