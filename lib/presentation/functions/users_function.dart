import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/greeting_message_provider.dart';
import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/bill_receipient_request.dart';
import 'package:utangq_app/domain/entities/bill_status.dart';
import 'package:utangq_app/domain/entities/friendship_status.dart';
import 'package:utangq_app/domain/entities/tax_status.dart';
import 'package:utangq_app/domain/entities/users.dart';
import 'package:utangq_app/domain/usecases/confirm_payment.dart';
import 'package:utangq_app/domain/usecases/delete_bill.dart';
import 'package:utangq_app/presentation/pages/login_page.dart';
import 'package:utangq_app/presentation/widgets/modal_success.dart';
import 'package:utangq_app/presentation/widgets/modal_wallet_balance.dart';
import 'package:utangq_app/presentation/widgets/modal_warning.dart';

void logout(BuildContext context) async {
  try {
    // Clear the Hive box
    await Hive.box(UsersRepository.boxName).clear();
    Provider.of<GreetingMessageProvider>(context, listen: false).clearData();
    print('Hive cleared');
  } finally {
    // Close the Hive box
    await Hive.close();
    print('Hive closed');

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}

String getUsername(BuildContext context, int userId, List<Users> users) {
  final user = users.firstWhere((user) => user.userID == userId);
  return user != null ? user.username : '';
}

String getPhoneNumber(BuildContext context, int userId, List<Users> users) {
  final user = users.firstWhere((user) => user.userID == userId);
  return user != null ? user.userPhoneNumber : '';
}

String getBillStatus(
    BuildContext context, int billStatusId, List<BillStatus> billStatuses) {
  final billStatus =
      billStatuses.firstWhere((bill) => bill.billStatusID == billStatusId);
  return billStatus != null ? billStatus.billStatusDescription : '';
}

String getFriendshipStatus(
    BuildContext context, int friendshipStatusId, List<FriendshipStatus> friendshipStatuses) {
  final frienshipStatus =
  friendshipStatuses.firstWhere((status) => status.friendshipStatusID == friendshipStatusId);
  return frienshipStatus != null ? frienshipStatus.friendshipStatusDescription : '';
}

String getTaxStatus(
    BuildContext context, int taxStatusId, List<TaxStatus> taxStatuses) {
  final taxStatus =
      taxStatuses.firstWhere((tax) => tax.taxStatusID == taxStatusId);
  return taxStatus != null ? taxStatus.taxStatusDescription : '';
}

void deleteBill(BuildContext context, int billId) async {
  try {
    var result = await DeleteBill().execute(billId);
    if (result) {
      Navigator.pop(context);
      showSuccessAlert(context);
    } else {
      Navigator.pop(context);
      showWarningAlert(context);
    }
  } catch (e) {
    throw e;
  }
}

void showAddBalanceModal(BuildContext context, int userId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddBalanceModal(
        userId: userId,
      );
    },
  );
}

void showSuccessAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SuccessAlertModal();
    },
  );
}

void showWarningAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DangerAlertModal();
    },
  );
}
