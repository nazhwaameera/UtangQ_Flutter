import 'package:flutter/material.dart';
import 'package:utangq_app/data/exception/wallet_404_exception.dart';
import 'dart:io';
import 'package:utangq_app/domain/entities/wallet.dart';
import 'package:utangq_app/domain/usecases/create_user_wallet.dart';
import 'package:utangq_app/domain/usecases/get_user_wallet.dart';

class WalletBalanceProvider extends ChangeNotifier {
  double _walletBalance = 0;

  double get walletBalance => _walletBalance;

  // WalletBalanceProvider(int userId) {
  //   // Call the function to retrieve initial data
  //   getUserWalletBalance(userId);
  // }

  Future<void> getUserWalletBalance(int userId) async {
    if(userId == 0) {
        print('User id invalid');
    } else {
      try {
        // print('This is the userId $userId');
        Wallet userWallet = await GetUserWallet().execute(userId);
        _walletBalance = userWallet.walletBalance;
        notifyListeners(); // Notify listeners about the change in wallet balance
      } catch (e) {
        print('Error retrieving user wallet balance: $e');
        if (e is WalletNotFoundException) {
          // Handle wallet not found error
          print('User wallet not found, creating a new wallet...');
          await CreateWallet().execute(userId);
          // Retry to get user wallet
          Wallet? userWallet = await GetUserWallet().execute(userId);
          if (userWallet == null) {
            print(
                'Failed to load wallet: Wallet still not found after creation');
          } else {
            _walletBalance = userWallet.walletBalance;
            notifyListeners(); // Notify listeners about the change in wallet balance
          }
        }
      }
    }
  }

  Future<void> updateWalletBalance(int userId) async {
    try {
      _walletBalance = 0;
      await getUserWalletBalance(userId);
    } catch (e) {
      print('Error updating wallet balance: $e');
    }
  }

  void dispose() {
    // Cleanup tasks
    // Close streams, release resources, etc.
    super.dispose();
  }
}
