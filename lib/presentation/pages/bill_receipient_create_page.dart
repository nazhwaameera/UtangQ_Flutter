import 'package:flutter/material.dart';
import 'package:utangq_app/data/providers/greeting_message_provider.dart';
import 'package:utangq_app/domain/entities/bill_create.dart';
import 'package:utangq_app/domain/entities/bill_receipient_create.dart';
import 'package:utangq_app/domain/entities/bill_status.dart';
import 'package:utangq_app/domain/entities/tax_status.dart';
import 'package:utangq_app/domain/entities/users.dart';
import 'package:utangq_app/domain/usecases/create_bill.dart';
import 'package:utangq_app/domain/usecases/create_bill_receipient.dart';
import 'package:utangq_app/domain/usecases/get_all_tax_status.dart';
import 'package:utangq_app/domain/usecases/get_user_friends.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';
import 'package:utangq_app/presentation/pages/split_bill_page.dart';

class BillReceipientCreatePage extends StatefulWidget {
  final int userId;
  final int billId;

  const BillReceipientCreatePage({Key? key, required this.userId ,required this.billId})
      : super(key: key);
  @override
  _BillReceipientCreatePageState createState() =>
      _BillReceipientCreatePageState(userId, billId);
}

class _BillReceipientCreatePageState extends State<BillReceipientCreatePage> {
  final int userId;
  final int billId;
  final TextEditingController _totalUsersController = TextEditingController();
  final TextEditingController _taxChargedController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  late GreetingMessageProvider _greetingMessageProvider;
  late int _friendshipId = 0;
  late List<Users> _friendList = [];
  late List<TaxStatus> _taxStatusesList = [];
  late String selectedValue = 'Choose friend';
  late String selectedTaxValue = 'Choose tax status';
  bool _isSplitEvenly = false;

  _BillReceipientCreatePageState(this.userId, this.billId);

  @override
  void initState(){
    super.initState();
    print('Bill receipient page with bill id ${widget.billId} and user id $userId');
    _greetingMessageProvider = GreetingMessageProvider();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _greetingMessageProvider.getUserFriendship(userId);
    setState(() {
      _friendshipId = _greetingMessageProvider.friendshipId;
    });
    await getUserFriends(_friendshipId);
    await getAllTaxStatus();
  }

  Future<void> getUserFriends(int friendshipId) async {
    try {
      var listUserFriends = await GetUserFriends().execute(friendshipId);
      setState(() {
        _friendList = listUserFriends;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> getAllTaxStatus() async {
    try{
      var listTaxStatuses = await GetAllTaxStatuses().execute();
      setState(() {
        _taxStatusesList = listTaxStatuses;
      });
    } catch (e) {
      throw e;
    }
  }
  Future<void> _createBillReceipient() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Extracting data from text controllers
    final totalUsers = int.parse(_totalUsersController.text);
    final taxCharged = double.parse(_taxChargedController.text);

    BillReceipientCreate entity = BillReceipientCreate(
      billID: widget.billId,
      recipientUserID: int.parse(selectedValue),
      totalUsers: totalUsers,
      isSplitEvenly: _isSplitEvenly,
      taxStatusDescription: selectedTaxValue,
      taxCharged: taxCharged
    );

    try {
      var result = await CreateBillReceipient().execute(entity);
      if (result) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplitBillPage(userId: userId ,billId: billId!,)),
        );
      } else {
        showWarningAlert(context);
      }
      print(
          'BillReceipientCreate entity: ${widget.billId}, ${entity.recipientUserID}, ${entity.totalUsers}, ${entity.isSplitEvenly}, ${entity.taxStatusDescription}, ${entity.taxCharged}');
    } catch (e) {
      _errorMessage = "Failed to create a bill: $e";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: Text('Choose friend'),
        value: 'Choose friend',
      ),
    ];

    // Add friends from _friendList to dropdownItems
    _friendList.forEach((friend) {
      menuItems.add(
        DropdownMenuItem(
          child: Text(friend.username),
          value: friend.userID.toString(), // Assuming userId is of type int
        ),
      );
    });

    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownTaxItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: Text('Choose tax status'),
        value: 'Choose tax status',
      ),
    ];

    // Add friends from _friendList to dropdownItems
    _taxStatusesList.forEach((taxStatus) {
      menuItems.add(
        DropdownMenuItem(
          child: Text(taxStatus.taxStatusDescription),
          value: taxStatus.taxStatusDescription, // Assuming userId is of type int
        ),
      );
    });
    return menuItems;
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
          'Create Bill Receipient',
          style: TextStyle(
            fontSize: 24, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.white, // Set the text color to white
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Receipient Username',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      print('You choose user with id $selectedValue');
                    });
                  },
                  items: dropdownItems
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _totalUsersController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Users',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('Split Evenly'),
                value: _isSplitEvenly, // Add logic for checkbox state
                onChanged: (bool? value) {
                  setState(() {
                    _isSplitEvenly = value ?? false;
                  });
                },
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Tax Status',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  value: selectedTaxValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTaxValue = newValue!;
                      print('You choose tax with description $selectedTaxValue');
                    });
                  },
                  items: dropdownTaxItems
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _taxChargedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Tax Charged',
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
                      _createBillReceipient();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      // Set button background color to blue
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      'Split Bill',
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
      ),
    );
  }
}
