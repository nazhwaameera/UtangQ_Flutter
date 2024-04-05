import 'package:utangq_app/data/repository/transactions_repository.dart';
import 'package:utangq_app/domain/entities/payment_receipt_create.dart';

class MakePayment{
  var repository = TransactionsRepository();

  Future<bool> execute(PaymentReceiptCreate entity) async {
    try{
      return await repository.makePayment(entity);
    } catch(e) {
      print('Create payment failed: $e');
      throw Exception('Failed to create payment: $e');
    }
  }
}