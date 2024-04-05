import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:utangq_app/data/providers/bill_recipient_amount_id_provider.dart';
import 'package:utangq_app/data/providers/bill_recipient_amount_provider.dart';
import 'package:utangq_app/data/providers/bill_recipient_provider.dart';
import 'package:utangq_app/domain/entities/bill_receipient_request.dart';
import 'package:utangq_app/domain/entities/bill_status.dart';
import 'package:utangq_app/domain/entities/tax_status.dart';
import 'package:utangq_app/domain/entities/users.dart';
import 'package:utangq_app/domain/usecases/confirm_payment.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';

class BillReceipientsListView extends StatelessWidget {
  final int billId;
  final List<Users> listUsers;
  final List<BillStatus> listBillStatuses;
  final List<TaxStatus> listTaxStatuses;
  final Function() refreshDataCallback;

  const BillReceipientsListView(
      {Key? key,
      required this.billId,
      required this.listUsers,
      required this.listBillStatuses,
      required this.listTaxStatuses,
      required this.refreshDataCallback})
      : super(key: key);

  void actionPopUpItemSelected(
      BuildContext context, value, int billRecipientId) {
    String message = '';
    if (value == 'split_bill') {
      message = 'You selected split bill for $billId';
    } else if (value == 'edit_bill') {
      message = 'You selected split bill for $billId';
    } else if (value == 'confirm_payment') {
      message = 'You selected confirm payment for $billId';
      showPaymentConfirmationDialog(context, billRecipientId);
    }
    print(message);
  }

  void confirmPayment(int billRecipientId) async {
    BillRecipientRequest entity =
    BillRecipientRequest(billRecipientID: billRecipientId, newStatusID: 2);

    try {
      var result = await ConfirmPayment().execute(entity);
      if (result) {
        print('Payment created for bill recipient id $billRecipientId');
      } else {
        print('Payment failed to be created for bill recipient id $billRecipientId');
      }
    } catch (e) {
      throw e;
    }
  }

  void showPaymentConfirmationDialog(BuildContext context, int billRecipientId) async {
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
              padding: const EdgeInsets.fromLTRB(25.0, 40.0, 20.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: 'Are you sure you want to pay for this bill?',
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          confirmPayment(billRecipientId);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.green[100]),
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration) {
      Provider.of<BillRecipientAmountIdProvider>(context, listen: false)
          .updateBillRecipientAmount(billId);
      Provider.of<BillRecipientByBillIdProvider>(context, listen: false)
          .updateBillRecipients(billId);
    });
    return Consumer<BillRecipientByBillIdProvider>(
      builder: (context, billRecipientByBillIdProvider, _) {
        if (billRecipientByBillIdProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (billRecipientByBillIdProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(billRecipientByBillIdProvider.errorMessage),
          );
        } else {
          if (billRecipientByBillIdProvider.billRecipients.isEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: Text(
                'There is no bill yet. Start creating one.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Menu')),
                  DataColumn(label: Text('Receipient')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Bill Status')),
                  DataColumn(label: Text('Tax Status')),
                ],
                rows: billRecipientByBillIdProvider.billRecipients.map((bill) {
                  final backgroundColor = billRecipientByBillIdProvider
                          .billRecipients
                          .indexOf(bill)
                          .isOdd
                      ? Colors.white
                      : Colors.grey[200];
                  final billStatus = getBillStatus(
                      context, bill.billRecipientStatusID, listBillStatuses);
                  return DataRow(
                    color: MaterialStateProperty.all<Color>(backgroundColor!),
                    cells: [
                      DataCell(
                        PopupMenuButton(
                          itemBuilder: (context) {
                            // Define different menu items based on the bill status
                            if (billStatus == 'Pending') {
                              // Menu items for status1
                              return [
                                PopupMenuItem(
                                  value: 'edit_bill',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete_bill',
                                  child: Text('Delete'),
                                ),
                              ];
                            } else if (billStatus == 'Paid') {
                              // Menu items for status2
                              return [
                                PopupMenuItem(
                                  value: 'view_payment',
                                  child: Text('View Payment'),
                                ),
                              ];
                            } else if (billStatus == 'Cancelled') {
                              // Menu items for status2
                              return [
                                PopupMenuItem(
                                  value: 'edit_bill',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete_bill',
                                  child: Text('Delete'),
                                ),
                              ];
                            } else if (billStatus == 'Accepted') {
                              // Menu items for status2
                              return [
                                PopupMenuItem(
                                  value: 'view_payment',
                                  child: Text('View Payment'),
                                  enabled: false,
                                ),
                              ];
                            } else if (billStatus == 'Rejected') {
                              // Menu items for status2
                              return [
                                PopupMenuItem(
                                  value: 'resend',
                                  child: Text('Resend'),
                                  enabled: false,
                                ),
                                PopupMenuItem(
                                  value: 'edit_bill',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete_bill',
                                  child: Text('Delete'),
                                ),
                              ];
                            } else if (billStatus == 'Awaiting') {
                              // Menu items for status2
                              return [
                                PopupMenuItem(
                                  value: 'confirm_payment',
                                  child: Text('Confirm Payment'),
                                  enabled: true,
                                ),
                              ];
                            } else {
                              // Default menu items
                              return [
                                PopupMenuItem(
                                  value: 'default_action',
                                  child: Text('Action'),
                                  enabled: false,
                                ),
                              ];
                            }
                          },
                          onSelected: (String value) {
                            actionPopUpItemSelected(
                                context, value, bill.billRecipientID);
                          },
                        ),
                      ),
                      DataCell(Text(getUsername(
                          context, bill.recipientUserID, listUsers))),
                      DataCell(
                          Text('\$${bill.billRecipientAmount.toString()}')),
                      DataCell(Text(billStatus)),
                      DataCell(Text(getTaxStatus(context,
                          bill.billRecipientTaxStatusID, listTaxStatuses))),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        }
      },
    );
  }
}
