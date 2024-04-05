import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/wallet_balance_provider.dart';
import 'package:utangq_app/domain/entities/wallet_balance.dart';
import 'package:utangq_app/domain/usecases/update_wallet_balance.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';
import 'package:utangq_app/presentation/pages/users_page.dart';

class AddBalanceModal extends StatelessWidget {
  final TextEditingController balanceController = TextEditingController();
  final int userId;

  AddBalanceModal({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Wallet Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Balance Amount',
                hintText: 'Enter the amount of balance you want to add.',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add logic to close the modal
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    double balanceAmount = double.parse(balanceController.text);
                    // Add logic to add balance
                    WalletBalance walletCreateDTO = WalletBalance(
                      amount: balanceAmount,
                      userID: userId,
                      operationFlag: 'A',
                    );

                    try{
                      bool result = await UpdateWalletBalance().execute(walletCreateDTO);

                      if(result){
                        Provider.of<WalletBalanceProvider>(context, listen: false).updateWalletBalance(userId);
                        Navigator.of(context).pop();
                        showSuccessAlert(context);
                      } else {
                        Navigator.of(context).pop();
                        showWarningAlert(context);
                      }
                    } catch(e){
                      throw Exception('Failed to update wallet balance: $e');
                    }
                  },
                  child: Text('Add Balance'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
