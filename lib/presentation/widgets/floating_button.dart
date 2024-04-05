import 'package:flutter/material.dart';
import 'package:utangq_app/presentation/pages/bill_create_page.dart';

class FloatingButton extends StatelessWidget {
  final int userId;
  const FloatingButton({Key? key, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.amber,
      tooltip: 'Create New Bill', // Tooltip text displayed on long press
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BillCreatePage(userId: userId,)),
        );
      },
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}

