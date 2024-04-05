import 'package:flutter/cupertino.dart';
import 'package:utangq_app/domain/usecases/get_bill_recipient_amount_by_bill_id.dart';

class BillRecipientAmountProvider extends ChangeNotifier {
  final GetBillRecipientAmountbyBillId _getBillRecipientAmountbyBillId = GetBillRecipientAmountbyBillId();
  double _amount = 0.0;
  String _errorMessage = '';

  double get amount => _amount;
  String get errorMessage => _errorMessage;

  Future<void> fetchBillRecipientAmount(int billId) async {
    try {
      _amount = await _getBillRecipientAmountbyBillId.execute(billId);
      // print('This is bill amount from bill id $billId: $_amount');
      _errorMessage = '';

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch bill recipient amount: $e';
      notifyListeners();
    }
  }

  Future<void> updateBillRecipientAmount(int billId) async{
    try {
      _amount = 0;
      await fetchBillRecipientAmount(billId);
    } catch (e) {
      print('Error fetching bill recipient amount: $e');
    }
  }
}