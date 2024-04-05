import 'package:flutter/material.dart';
import 'package:utangq_app/presentation/pages/bill_create_page.dart';
import 'package:utangq_app/presentation/pages/bill_receipient_create_page.dart';

class FloatingButtonBillRecipient extends StatelessWidget {
  final int userId;
  final int? billId;

  const FloatingButtonBillRecipient({Key? key, required this.userId, this.billId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color(0xFFA88FE8),
      tooltip: 'Create New Bill Recipient', // Tooltip text displayed on long press
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BillReceipientCreatePage(userId: userId ,billId: billId!,)),
        );
      },
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}

