import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:utangq_app/data/providers/user_payments_provider.dart';
import 'package:utangq_app/domain/entities/payment_receipt_create.dart';
import 'package:utangq_app/domain/usecases/create_payment.dart';

class UserPaymentsListView extends StatelessWidget {
  final int userId;
  final Function() refreshDataCallback;

  const UserPaymentsListView({
    Key? key,
    required this.userId,
    required this.refreshDataCallback,
  }) : super(key: key);

  Future<void> makePayment(int billRecipientId) async{
    PaymentReceiptCreate entity = PaymentReceiptCreate.withCurrentDate(
        billRecipientID: billRecipientId);

    try{
      var result = await MakePayment().execute(entity);
      if(result){
        print('Succesfully created payment for the bill recipient with id ${entity.billRecipientID}');
        refreshDataCallback();
      } else {
        print('Failed to create payment for the bill recipient with id ${entity.billRecipientID}');
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
    return SingleChildScrollView(
      child: Consumer<UserPaymentsProvider>(
        builder: (context, userPaymentsProvider, _) {
          if (userPaymentsProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (userPaymentsProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(userPaymentsProvider.errorMessage),
            );
          } else {
            if (userPaymentsProvider.payments.isEmpty) {
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
                shrinkWrap: true, // Added to make ListView scrollable inside SingleChildScrollView
                physics: NeverScrollableScrollPhysics(), // Disable ListView scroll behavior
                itemCount: userPaymentsProvider.payments
                    .where((payment) => payment.billRecipientStatus != 'Rejected' && payment.billRecipientStatus != 'Pending')
                    .length,
                itemBuilder: (context, index) {
                  final nonRejectedPayments = userPaymentsProvider.payments
                      .where((payment) => payment.billRecipientStatus != 'Rejected'&& payment.billRecipientStatus != 'Pending')
                      .toList();
                  final payment = nonRejectedPayments[index];
                  final backgroundColor =
                  index.isOdd ? Colors.white : Colors.grey[200];
                  final formattedDate =
                  DateFormat('dd/MM/yyyy').format(payment.sentDate);
                  return Dismissible(
                    key: Key('bill_$index'),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart && payment.billRecipientStatus == 'Accepted') {
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
                                            'Are you sure you want to pay for this bill?',
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
                                                await makePayment(payment.billRecipientID);
                                                Navigator.pop(context);
                                                dismiss = false;
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
                      } else if (direction == DismissDirection.endToStart) {
                        bool dismiss = false;
                        return dismiss;
                      }
                    },
                    direction: DismissDirection.endToStart, // Set direction to endToStart
                    background: Container(
                      color: payment.billRecipientStatus == 'Accepted' ? Colors.blue :
                      payment.billRecipientStatus == 'Paid' ? Colors.grey :
                      Colors.grey[300], // Set background color based on payment status
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            payment.billRecipientStatus == 'Accepted' ? Icons.payment :
                            payment.billRecipientStatus == 'Paid' ? Icons.receipt :
                            Icons.hourglass_empty, // Icon for different payment statuses
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      (index + 1).toString(), // Current Index
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      formattedDate, // Bill Date
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      payment.billDescription, // Bill Description
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
      ),
    );

  }
}