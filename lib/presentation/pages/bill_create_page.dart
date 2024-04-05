import 'package:flutter/material.dart';
import 'package:utangq_app/domain/entities/bill_create.dart';
import 'package:utangq_app/domain/usecases/create_bill.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';

class BillCreatePage extends StatefulWidget {
  final int userId;

  const BillCreatePage({Key? key, required this.userId}) : super(key: key);

  @override
  _BillCreatePageState createState() => _BillCreatePageState(userId);
}

class _BillCreatePageState extends State<BillCreatePage> {
  final int userId;
  final TextEditingController _billAmountController = TextEditingController();
  final TextEditingController _billDateController = TextEditingController();
  final TextEditingController _billDescriptionController = TextEditingController();
  final TextEditingController _ownerContributionController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  _BillCreatePageState(this.userId);

  Future<void> _createBill() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Extracting data from text controllers
    final billAmount = double.parse(_billAmountController.text);
    final billDate = DateTime.parse(_billDateController.text);
    final billDescription = _billDescriptionController.text;
    final ownerContribution = double.parse(_ownerContributionController.text);

    BillCreate entity = BillCreate(
        userID: userId,
        billAmount: billAmount,
        billDate: billDate,
        billDescription: billDescription,
        ownerContribution: ownerContribution
    );

    try {
      var result = await CreateBill().execute(entity);
      if(result){
        showSuccessAlert(context);
        _resetFields();
      }
      else{
        showWarningAlert(context);
      }
      print('BillCreate entity: $userId, $billAmount, $billDescription, $billDate, $ownerContribution');
    } catch (e) {
      _errorMessage = "Failed to create a bill: $e";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetFields() {
    _billAmountController.clear();
    _billDateController.clear();
    _billDescriptionController.clear();
    _ownerContributionController.clear();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
          'Create Bill',
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
                    _createBill();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Set button background color to blue
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    'Save',
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
