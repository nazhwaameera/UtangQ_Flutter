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
    if (userId == 0) {
      print('User id invalid');
    } else {
      try {
        // Attempt to retrieve the user's wallet
        Wallet userWallet = await GetUserWallet().execute(userId);
        _walletBalance = userWallet.walletBalance;
        notifyListeners(); // Notify listeners about the change in wallet balance
      } catch (e) {
        print('Error retrieving user wallet balance: $e');
        if (e is WalletNotFoundException) {
          // Handle wallet not found error
          print('User wallet not found, creating a new wallet...');
          // Create the user's wallet
          await CreateWallet().execute(userId);
          // Wait for a short delay to ensure the wallet creation is processed
          await Future.delayed(Duration(seconds: 1));
          // Retry to get user wallet
          try {
            Wallet userWallet = await GetUserWallet().execute(userId);
            _walletBalance = userWallet.walletBalance;
            notifyListeners(); // Notify listeners about the change in wallet balance
          } catch (e) {
            print('Failed to load wallet: $e');
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
