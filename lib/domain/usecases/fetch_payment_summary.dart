import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/payment_summary.dart';

class FetchPaymentSummary{
  var repository = UsersRepository();

  Future<PaymentSummary> execute(int recipientUserId) async{
    try{
      final result = await repository.fetchPaymentSummary(recipientUserId);
      print('Usecase payment $result');
      return result;
    } catch (e){
      throw e;
    }
  }
}