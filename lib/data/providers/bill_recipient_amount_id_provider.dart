import 'package:flutter/cupertino.dart';
import 'package:utangq_app/domain/usecases/get_bill_recipient_amount_by_bill_id.dart';

class BillRecipientAmountIdProvider extends ChangeNotifier {
  final GetBillRecipientAmountbyBillId _getBillRecipientAmountbyBillId = GetBillRecipientAmountbyBillId();
  double _amount = 0.0;
  String _errorMessage = '';
  int _billId = 0;

  double get amount => _amount;
  String get errorMessage => _errorMessage;
  int get billId => _billId;

  Future<void> fetchBillRecipientAmount(int billId) async {
    try {
      _billId = billId;
      // print('Masuk provider fetch amount per id: $_billId');
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
      _billId = 0;
      await fetchBillRecipientAmount(billId);
    } catch (e) {
      print('Error fetching bill recipient amount: $e');
    }
  }

  void dispose() async {
    _billId = 0;
    _amount = 0;
    notifyListeners();
  }

}