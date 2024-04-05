import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utangq_app/data/exception/bill_404_exception.dart';
import 'package:utangq_app/domain/entities/bill.dart';
import 'package:utangq_app/domain/entities/bill_create.dart';
import 'package:utangq_app/domain/usecases/create_bill.dart';
import 'package:utangq_app/domain/usecases/get_bill_by_id.dart';
import 'package:utangq_app/domain/usecases/update_bill.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';
import 'package:utangq_app/presentation/pages/manage_bill_page.dart';

class BillEditPage extends StatefulWidget {
  final int userId;
  final int billId;

  const BillEditPage({Key? key, required this.userId, required this.billId}) : super(key: key);
  @override
  _BillEditPageState createState() => _BillEditPageState(userId, billId);
}

class _BillEditPageState extends State<BillEditPage> {
  final int userId;
  final int billId;
  final getBillById = GetBillById();

  late Bill bill;
  late TextEditingController _billAmountController = TextEditingController();
  late TextEditingController _billDateController = TextEditingController();
  late TextEditingController _billDescriptionController = TextEditingController();
  late TextEditingController _ownerContributionController = TextEditingController();

  Future<void> fetchBillData(int billId) async {
    try {
      bill = await GetBillById().execute(billId);
      if(bill == null) {
          throw BillNotFoundException();
      }
      setState(() {
        _billAmountController = TextEditingController(text: NumberFormat("#,##0.00", "en_US").format(bill.billAmount));
        _billDateController = TextEditingController(text: bill.billDate.toIso8601String().split('T')[0]);
        _billDescriptionController = TextEditingController(text: bill.billDescription);
        _ownerContributionController = TextEditingController(text: NumberFormat("#,##0.00", "en_US").format(bill.ownerContribution));
      });
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print('Error fetching bill data: $e');
    }
  }

  void initState(){
    super.initState();
    _billAmountController = TextEditingController();
    _billDateController = TextEditingController();
    _billDescriptionController = TextEditingController();
    _ownerContributionController = TextEditingController();
    fetchBillData(billId);
  }

  bool _isLoading = false;
  String _errorMessage = '';

  _BillEditPageState(this.userId, this.billId);

  Future<void> _updateBill() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Extracting data from text controllers
    final billAmount = double.parse(_billAmountController.text);
    final billDate = DateTime.parse(_billDateController.text);
    final billDescription = _billDescriptionController.text;
    final ownerContribution = double.parse(_ownerContributionController.text);

    Bill entity = Bill(
        billID: billId,
        userID: userId,
        billAmount: billAmount,
        billDate: billDate,
        billDescription: billDescription,
        ownerContribution: ownerContribution
    );

    try {
      var result = await UpdateBill().execute(entity);
      if(result){
        showSuccessAlert(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ManageBillPage(userId: userId,)),
        // );
      }
      else{
        showWarningAlert(context);
      }
      print('Bill update entity: $userId, $billAmount, $billDescription, $billDate, $ownerContribution');
    } catch (e) {
      _errorMessage = "Failed to create a bill: $e";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = _billDateController.text.isNotEmpty
        ? DateTime.parse(_billDateController.text)
        : DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _billDateController.text = pickedDate.toIso8601String().split('T')[0];
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
                Color(0xFFB99CFF), // Lighter version of Colors.lightBlue
                Color(0xFFA88FE8), // Lighter version of Colors.lightBlue
                Color(0xFFD0B3FF), // Lighter version of Colors.lightBlue
                Color(0xFFFFE57F), // Lighter version of Colors.lightBlue
              ],
            ),
          ),
        ),
        title: Text(
          'Edit Bill',
          style: TextStyle(
            fontSize: 24, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.white, // Set the text color to white
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _billAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Bill Amount',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _billDateController,
              readOnly: true,
              onTap: () {
                _selectDate(context);
              },
              decoration: InputDecoration(
                labelText: 'Bill Date (YYYY-MM-DD)',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _billDescriptionController,
              decoration: InputDecoration(
                labelText: 'Bill Description',
                prefixIcon: Icon(Icons.receipt),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _ownerContributionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Owner Contribution',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 40.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _updateBill();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Set button background color to blue
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    'Save Edit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
