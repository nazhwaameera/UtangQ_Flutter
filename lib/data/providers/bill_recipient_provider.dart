import 'package:flutter/material.dart';
import 'package:utangq_app/domain/entities/bill_recipient.dart';
import 'package:utangq_app/domain/usecases/get_bill_recipient_by_bill_id.dart';

class BillRecipientByBillIdProvider extends ChangeNotifier {
  final GetBillRecipientByBillId _getBillRecipientByBillId = GetBillRecipientByBillId();
  List<BillRecipient> _billRecipients = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<BillRecipient> get billRecipients => _billRecipients;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchBillRecipients(int billId) async {
    try {
      _isLoading = true;

      _billRecipients = await _getBillRecipientByBillId.execute(billId);
      _errorMessage = '';

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch bill recipients: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateBillRecipients(int billId) async{
    _billRecipients.clear();
    await fetchBillRecipients(billId);
  }
}