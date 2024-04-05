import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/bill_summary.dart';

class FetchBillSummary{
  var repository = UsersRepository();

  Future<BillSummary> execute(int userId) async{
    try{
      final result = await repository.fetchBillSummary(userId);
      print('Usecase $result');
      return result;
    } catch (e){
      throw e;
    }
  }
}