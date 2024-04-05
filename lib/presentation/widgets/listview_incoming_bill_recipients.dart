import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:utangq_app/data/providers/user_payments_provider.dart';
import 'package:utangq_app/domain/entities/bill_receipient_request.dart';
import 'package:utangq_app/domain/usecases/handle_incoming_bill_recipient.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';

class UserIncomingBillRecipientsListView extends StatelessWidget {
  final int userId;
  final Function() refreshDataCallback;

  const UserIncomingBillRecipientsListView({
    Key? key,
    required this.userId,
    required this.refreshDataCallback,
  }) : super(key: key);

  Future<void> acceptBillrecipient(int billRecipientId) async{
    BillRecipientRequest entity = BillRecipientRequest(
        billRecipientID: billRecipientId,
        newStatusID: 9);

    try{
      var result = await HandleIncomingBillRecipient().execute(entity);
      if(result){
        print('Succesfully accepted the bill recipient with id ${entity.billRecipientID}');
        refreshDataCallback();
      } else {
        print('Failed to accept the bill recipient with id ${entity.billRecipientID}');
      }
    } catch(e) {
      throw e;
    }
  }

  Future<void> rejectBillrecipient(int billRecipientId) async{
    BillRecipientRequest entity = BillRecipientRequest(
        billRecipientID: billRecipientId,
        newStatusID: 5);

    try{
      var result = await HandleIncomingBillRecipient().execute(entity);
      if(result){
        print('Succesfully rejected the bill recipient with id ${entity.billRecipientID}');
      } else {
        print('Failed to reject the bill recipient with id ${entity.billRecipientID}');
      }
    } catch(e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration) {
      Provider.of<UserPaymentsProvider>(context, listen: false)
          .updateUserPayments(userId);
    });
    return Consumer<UserPaymentsProvider>(
      builder: (context, userPaymentsProvider, _) {
        if (userPaymentsProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (userPaymentsProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(userPaymentsProvider.errorMessage),
          );
        } else {
          if (userPaymentsProvider.payments
              .where((payment) => payment.billRecipientStatus == 'Pending')
              .isEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: Text(
                'There is no payment yet. Start splitting bill with friend.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: userPaymentsProvider.payments
                  .where((payment) => payment.billRecipientStatus == 'Pending')
                  .length,
              itemBuilder: (context, index) {
                final nonRejectedPayments = userPaymentsProvider.payments
                    .where(
                        (payment) => payment.billRecipientStatus == 'Pending')
                    .toList();

                final payment = nonRejectedPayments[index];
                print('Bill to be paid amount: ${nonRejectedPayments.length}');
                final backgroundColor =
                    index.isOdd ? Colors.white : Colors.grey[200];
                final formattedDate =
                    DateFormat('dd/MM/yyyy').format(payment.sentDate);

                return Dismissible(
                  key: Key(payment.billID.toString()),
                  onDismissed: (direction) {
                    // Remove the item from the data source
                    // setState(() {
                    //   nonRejectedPayments.removeAt(index);
                    // });
                    // Then show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Item dismissed'),
                    ));
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  secondaryBackground: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      bool dismiss = false;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxHeight: 170),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 40.0, 20.0, 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          text:
                                              'Are you sure you want to reject this bill?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Colors.black,
                                            wordSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300]),
                                            child: Text('Close',
                                                style: TextStyle(
                                                    color: Colors.grey[700])),
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () async{
                                              await rejectBillrecipient(payment.billRecipientID);
                                              Navigator.pop(context);
                                              dismiss = true;
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red[700]),
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color: Colors.red[100])),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                      return dismiss;
                    } else if (direction == DismissDirection.endToStart) {
                      bool dismiss = false;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxHeight: 170),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 40.0, 20.0, 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          text:
                                              'Are you sure you want to accept this bill?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Colors.black,
                                            wordSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300]),
                                            child: Text('Close',
                                                style: TextStyle(
                                                    color: Colors.grey[700])),
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await acceptBillrecipient(payment.billRecipientID);
                                              Navigator.pop(context);
                                              dismiss = true;
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.green[700]),
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color: Colors.green[100])),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                      return dismiss;
                    }
                  },
                  child: Container(
                    color: backgroundColor,
                    child: ListTile(
                      title: Table(
                        columnWidths: {
                          0: FlexColumnWidth(1), // Index
                          1: FlexColumnWidth(3), // Bill Date
                          2: FlexColumnWidth(4), // Bill Description
                          3: FlexColumnWidth(2), // Bill Amount
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    (index + 1).toString(), // Current Index
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    formattedDate, // Bill Date
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    payment.billDescription,
                                    // Bill Description
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '\$${payment.billRecipientAmount.toString()}',
                                    // Bill Amount
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
