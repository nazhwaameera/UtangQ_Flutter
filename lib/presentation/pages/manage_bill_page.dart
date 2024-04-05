import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utangq_app/data/providers/bill_summary_provider.dart';
import 'package:utangq_app/data/providers/user_bills_provider.dart';
import 'package:utangq_app/presentation/widgets/bill_summary_card.dart';
import 'package:utangq_app/presentation/widgets/horizontal_bar_widget.dart';
import 'package:utangq_app/presentation/widgets/listview_user_bills.dart';

class ManageBillPage extends StatefulWidget {
  final int userId;

  const ManageBillPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ManageBillPageState createState() => _ManageBillPageState(userId);
}

class _ManageBillPageState extends State<ManageBillPage> {
  final int userId;
  bool _isLoading = false;
  String _errorMessage = '';

  _ManageBillPageState(this.userId);

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

      await Provider.of<BillSummaryProvider>(context, listen: false)
          .fetchBillSummary(userId);
      await Provider.of<UserBillsProvider>(context, listen: false)
          .updateUserBills(userId);

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
          'Manage Bill',
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
                  Consumer<BillSummaryProvider>(
                    builder: (context, billProvider, _) {
                      List<ChartData> chartDataProvider =
                          billProvider.chartData;
                      return BillSummaryCard(
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
                      'Bill Details', // Title text
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
                        return UserBillsListView(userId: userId);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
