import 'package:flutter/material.dart';
import 'package:utangq_app/domain/entities/bill_summary.dart';
import 'package:utangq_app/domain/usecases/fetch_bill_summary.dart';
import 'package:utangq_app/presentation/widgets/horizontal_bar_widget.dart';

class BillSummaryProvider extends ChangeNotifier {
  late BillSummary _billSummary;
  List<ChartData> _chartData = [];

  BillSummary get billSummary => _billSummary;

  List<ChartData> get chartData => _chartData;

  // BillSummaryProvider(int userId){
  //   fetchBillSummary(userId);
  // }

  Future<void> fetchBillSummary(int userId) async {
    if (userId == 0) {
      print('User id invalid');
    } else {
      try {
        _billSummary = await FetchBillSummary().execute(userId);
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
    double totalCreatedBills = _billSummary.totalBillAmountCreated;
    double perAccepted =
        (_billSummary.totalBillAmountCreatedAccepted / totalCreatedBills) * 100;
    double perAwaiting =
        (_billSummary.totalBillAmountCreatedAwaiting / totalCreatedBills) * 100;
    double perPaid =
        (_billSummary.totalBillAmountCreatedPaid / totalCreatedBills) * 100;
    double perPending =
        (_billSummary.totalBillAmountCreatedPending / totalCreatedBills) * 100;
    double perRejected =
        (_billSummary.totalBillAmountCreatedRejected / totalCreatedBills) * 100;
    double perUnassigned =
        (_billSummary.totalBillUnassigned / totalCreatedBills) * 100;

    _chartData = [
      ChartData('', perUnassigned, perPending, perRejected, perAccepted,
          perAwaiting, perPaid),
    ];
  }

  void dispose() {
    // Cleanup tasks
    // Close streams, release resources, etc.
    super.dispose();
  }
}
