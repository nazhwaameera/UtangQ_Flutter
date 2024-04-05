import 'package:flutter/cupertino.dart';
import 'package:utangq_app/domain/entities/payment_summary.dart';
import 'package:utangq_app/domain/usecases/fetch_payment_summary.dart';
import 'package:utangq_app/presentation/widgets/horizontal_bar_widget_2.dart';

class PaymentSummaryProvider extends ChangeNotifier {
  late PaymentSummary _paymentSummary;
  List<ChartData2> _chartData = [];

  PaymentSummary get paymentSummary => _paymentSummary;

  List<ChartData2> get chartData => _chartData;

  Future<void> fetchPaymentSummary(int userId) async {
    if (userId == 0) {
      print('User id invalid');
    } else {
      try {
        _paymentSummary = await FetchPaymentSummary().execute(userId);
        // print('This is bill summary $_billSummary');
        _updateChartData();
        notifyListeners();
      } catch (e) {
        print('Failed to fetch bill summary: $e');
      }
    }
  }

  void _updateChartData() {
    // Clear existing chart data
    _chartData.clear();
    double totalOwedBills = _paymentSummary.totalPendingAmountOwed + _paymentSummary.totalBillAmountAccepted + _paymentSummary.totalBillAmountAwaiting + _paymentSummary.totalBillAmountPaid;
    double perAccepted =
        (_paymentSummary.totalBillAmountAccepted / totalOwedBills) * 100;
    double perAwaiting =
        (_paymentSummary.totalBillAmountAwaiting / totalOwedBills) * 100;
    double perPaid =
        (_paymentSummary.totalBillAmountPaid / totalOwedBills) * 100;
    double perPending =
        (_paymentSummary.totalPendingAmountOwed / totalOwedBills) * 100;

    _chartData = [
      ChartData2('', perPending, perAccepted, perAwaiting, perPaid),
    ];
  }

}