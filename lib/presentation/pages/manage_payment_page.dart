import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utangq_app/data/providers/payment_summary_provider.dart';
import 'package:utangq_app/data/providers/user_bills_provider.dart';
import 'package:utangq_app/data/providers/user_payments_provider.dart';
import 'package:utangq_app/domain/entities/bill_status.dart';
import 'package:utangq_app/domain/entities/tax_status.dart';
import 'package:utangq_app/domain/usecases/get_all_bill_status.dart';
import 'package:utangq_app/domain/usecases/get_all_tax_status.dart';
import 'package:utangq_app/presentation/widgets/bill_summary_card.dart';
import 'package:utangq_app/presentation/widgets/horizontal_bar_widget_2.dart';
import 'package:utangq_app/presentation/widgets/listview_incoming_bill_recipients.dart';
import 'package:utangq_app/presentation/widgets/listview_user_bills.dart';
import 'package:utangq_app/presentation/widgets/listview_user_payments.dart';
import 'package:utangq_app/presentation/widgets/payment_summary_card.dart';

class ManagePaymentPage extends StatefulWidget {
  final int userId;

  const ManagePaymentPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ManagePaymentPageState createState() => _ManagePaymentPageState(userId);
}

class _ManagePaymentPageState extends State<ManagePaymentPage> {
  final int userId;

  bool _isLoading = false;
  String _errorMessage = '';

  _ManagePaymentPageState(this.userId);

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<PaymentSummaryProvider>(context, listen: false)
          .fetchPaymentSummary(userId);
      await Provider.of<UserPaymentsProvider>(context, listen: false)
          .updateUserPayments(userId);

      setState(() {
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void refreshData() {
    setState(() {
      _isLoading = true;
    });
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFB99CFF),
                Color(0xFFA88FE8),
                Color(0xFFD0B3FF),
                Color(0xFFFFE57F),
              ],
            ),
          ),
        ),
        title: Text(
          'Manage Payment',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            Consumer<PaymentSummaryProvider>(
              builder: (context, paymentSummaryProvider, _) {
                List<ChartData2> chartDataProvider =
                    paymentSummaryProvider.chartData;
                return PaymentSummaryCard(
                  userId: userId,
                  chartData: chartDataProvider,
                );
              },
            ),
            SizedBox(height: 10.0),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Incoming Bill to be Paid', // Title text
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 75,
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: // Add spacing between title and content
              Consumer<UserBillsProvider>(
                builder: (context, userBillsProvider, _) {
                  return UserIncomingBillRecipientsListView(userId: userId, refreshDataCallback: refreshData,);
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Payment Details', // Title text
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 400,
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: // Add spacing between title and content
              Consumer<UserBillsProvider>(
                builder: (context, userBillsProvider, _) {
                  return UserPaymentsListView(userId: userId, refreshDataCallback: refreshData,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}