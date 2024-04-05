import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/bill_recipient_amount_id_provider.dart';
import 'package:utangq_app/data/providers/bill_recipient_amount_provider.dart';
import 'package:utangq_app/data/providers/bill_recipient_provider.dart';
import 'package:utangq_app/domain/entities/bill_status.dart';
import 'package:utangq_app/domain/entities/tax_status.dart';
import 'package:utangq_app/domain/entities/users.dart';
import 'package:utangq_app/domain/usecases/get_all_bill_status.dart';
import 'package:utangq_app/domain/usecases/get_all_tax_status.dart';
import 'package:utangq_app/domain/usecases/get_all_users.dart';
import 'package:utangq_app/presentation/widgets/floating_button_br.dart';
import 'package:utangq_app/presentation/widgets/listview_bill_receipients.dart';
class SplitBillPage extends StatefulWidget {
  final int userId;
  final int? billId;

  const SplitBillPage({Key? key, required this.userId,  this.billId}) : super(key: key);

  @override
  _SplitBillPageState createState() => _SplitBillPageState(userId, billId!);
}

class _SplitBillPageState extends State<SplitBillPage> {
  final int billId;
  final int userId;
  bool _isLoading = false;
  String _errorMessage = '';
  late List<Users> _userList = [];
  late List<BillStatus> _billStatusesList = [];
  late List<TaxStatus> _taxStatusesList = [];

  _SplitBillPageState(this.userId, this.billId);

  @override
  void initState() {
    super.initState();
    getAllUsers();
    getBillStatuses();
    getTaxStatuses();
    _refreshData();
  }

  Future<void> getAllUsers() async{
    try{
      var listUsers = await GetAllUsers().execute();
      setState(() {
        _userList = listUsers;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> getBillStatuses() async{
    try{
      var listBillStatuses = await GetAllBillStatuses().execute();
      setState(() {
        _billStatusesList = listBillStatuses;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> getTaxStatuses() async{
    try{
      var listTaxStatuses = await GetAllTaxStatuses().execute();
      setState(() {
        _taxStatusesList = listTaxStatuses;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> _refreshData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<BillRecipientAmountProvider>(context, listen: false)
          .fetchBillRecipientAmount(billId);
      await Provider.of<BillRecipientByBillIdProvider>(context, listen: false)
          .fetchBillRecipients(billId);

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
          'Bill Recipients for Bill $billId',
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
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Bill Receipients Details', // Title text
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Consumer<BillRecipientAmountIdProvider>(
                  builder: (context, billRecipientAmountIdProvider, _) {
                    double amount = billRecipientAmountIdProvider.amount;
                    String formattedAmount = '\$$amount';
                    if (amount < 0) {
                      formattedAmount = '\$${(amount * -1)}'; // Negate amount if it's less than 0
                    }
                    return RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Set your desired text color
                        ),
                        children: [
                          TextSpan(
                            text: 'Bills remaining amount: ',
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.grey),
                          ),
                          TextSpan(
                            text: formattedAmount,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 400,
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: // Add spacing between title and content
              Consumer<BillRecipientByBillIdProvider>(
                builder: (context, billRecipientByBillId, _) {
                  return BillReceipientsListView(billId: billId, listUsers: _userList, listBillStatuses: _billStatusesList, listTaxStatuses: _taxStatusesList, refreshDataCallback: refreshData,);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<BillRecipientAmountIdProvider>(
        builder: (context, billRecipientAmountByBillId, _) {
          print('Creating bill recipient with user id $userId and bill id ${billRecipientAmountByBillId.billId}, $billId');
          return FloatingButtonBillRecipient(userId: userId, billId: billRecipientAmountByBillId.billId,);
        }
      ),
    );
  }
}