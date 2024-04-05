import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:utangq_app/data/providers/bill_recipient_amount_provider.dart';
import 'package:utangq_app/data/providers/user_bills_provider.dart';
import 'package:utangq_app/presentation/pages/bill_edit_page.dart';
import 'package:utangq_app/presentation/pages/split_bill_page.dart';
import 'package:utangq_app/presentation/widgets/modal_delete_bill.dart';

class UserBillsListView extends StatelessWidget {
  final int userId;

  const UserBillsListView({Key? key, required this.userId}) : super(key: key);

  void actionPopUpItemSelected(BuildContext context, value, int billId) {
    String message;
    if (value == 'split_bill') {
      message = 'You selected split bill for $billId';
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SplitBillPage(userId: userId, billId: billId)),
      );
    } else if (value == 'edit_bill') {
      message = 'You selected split bill for $billId';
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BillEditPage(userId: userId, billId: billId)),
      );
    } else {
      showDeleteModalDialog(
          context, 'Are you sure you want to delete this bill?', billId);
      message = 'You selected delete for $billId';
    }
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration) {
      Provider.of<UserBillsProvider>(context, listen: false)
          .updateUserBills(userId);
    });
    return Consumer<UserBillsProvider>(
      builder: (context, userBillsProvider, _) {
        if (userBillsProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (userBillsProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(userBillsProvider.errorMessage),
          );
        } else {
          if (userBillsProvider.bills.isEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: Text(
                'There is no bill yet. Start creating one.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: userBillsProvider.bills.length,
              itemBuilder: (context, index) {
                final bill = userBillsProvider.bills[index];
                final backgroundColor =
                    index.isOdd ? Colors.white : Colors.grey[200];
                final formattedDate =
                    DateFormat('dd/MM/yyyy').format(bill.billDate);
                return Container(
                    color: backgroundColor,
                    child: ListTile(
                      title: Table(
                        columnWidths: {
                          0: FlexColumnWidth(1), // Index
                          1: FlexColumnWidth(3), // Bill Date
                          2: FlexColumnWidth(4), // Bill Description
                          3: FlexColumnWidth(2), // Bill Amount
                          4: FlexColumnWidth(1), // Trailing Menu
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
                                    bill.billDescription, // Bill Description
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '\$${bill.billAmount.toString()}',
                                    // Bill Amount
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Consumer<BillRecipientAmountProvider>(
                                    builder: (context,
                                        billRecipientAmountProvider, _) {
                                  Provider.of<BillRecipientAmountProvider>(
                                          context,
                                          listen: false)
                                      .fetchBillRecipientAmount(bill.billID);
                                  return PopupMenuButton(
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          value: 'split_bill',
                                          child: Text('Split Bill'),
                                        ),
                                        PopupMenuItem(
                                          value: 'edit_bill',
                                          child: Text('Edit'),
                                          enabled: billRecipientAmountProvider
                                                  .amount <
                                              0.0,
                                        ),
                                        PopupMenuItem(
                                          value: 'delete_bill',
                                          child: Text('Delete'),
                                          enabled: billRecipientAmountProvider
                                                  .amount <
                                              0.0,
                                        ),
                                      ];
                                    },
                                    onSelected: (String value) {
                                      actionPopUpItemSelected(
                                          context, value, bill.billID);
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
              },
            );
          }
        }
      },
    );
  }
}
