import 'package:flutter/material.dart';
import 'package:utangq_app/data/exception/bill_404_exception.dart';
import 'package:utangq_app/domain/entities/bill.dart';
import 'package:utangq_app/domain/usecases/get_user_bills.dart';

class UserBillsProvider extends ChangeNotifier {
  final GetUserBills _getUserBills = GetUserBills();
  List<Bill> _bills = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Bill> get bills => _bills;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // UserBillsProvider(int userId){
  //   fetchUserBills(userId);
  // }

  Future<void> fetchUserBills(int userId) async {
    try {
      _isLoading = true;

      _bills = await _getUserBills.execute(userId);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
    } catch (e) {
      if(e is BillNotFoundException) {
        _isLoading = false;
        _bills = [];
        notifyListeners();
      } else {
        _isLoading = false;
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> updateUserBills(int userId) async{
    try{
      _bills.clear();
      _isLoading = false;
      _errorMessage = '';
      await fetchUserBills(userId);
    } catch(e) {
      throw e;
    }
  }
}