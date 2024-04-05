import 'package:utangq_app/data/repository/users_repository.dart';

class DeleteBill{
  var repository = UsersRepository();

  Future<bool> execute(int billId) async{
    try{
      return await repository.deleteBill(billId);
    } catch (e) {
      throw e;
    }
  }
}