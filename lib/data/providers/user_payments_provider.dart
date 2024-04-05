import 'package:flutter/material.dart';
import 'package:utangq_app/data/exception/payment_404_exception.dart';
import 'package:utangq_app/domain/usecases/get_user_payments.dart';
import 'package:utangq_app/domain/entities/bill_receipient_desc.dart';

class UserPaymentsProvider extends ChangeNotifier{
  final GetUserPayments _getUserPayments = GetUserPayments();
  List<BillRecipientWithDesc> _payments = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<BillRecipientWithDesc> get payments => _payments;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchUserPayments(int recipientUserId) async{
    try {
      _isLoading = true;

      _payments = await _getUserPayments.execute(recipientUserId);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
    } catch (e) {
      if(e is PaymentNotFoundException) {
        _isLoading = false;
        _payments = [];
        notifyListeners();
      } else {
        _isLoading = false;
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> updateUserPayments(int recipientUserId) async{
    try{
      _payments.clear();
      _isLoading = false;
      _errorMessage = '';
      await fetchUserPayments(recipientUserId);
    } catch(e) {
      throw e;
    }
  }
}