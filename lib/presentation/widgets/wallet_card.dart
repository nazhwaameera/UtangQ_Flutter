import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/wallet_balance_provider.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';

class WalletCard extends StatelessWidget {
  final int userId;

  const WalletCard({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletBalanceProvider>(context, listen: false)
          .updateWalletBalance(userId);
    });
    return Consumer<WalletBalanceProvider>(
      builder: (context, walletBalanceProvider, _) {
        return Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF846AFF),
                Color(0xFF755EE8),
                Colors.purpleAccent,
                Colors.amber,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Wallet Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "monospace",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        children: List.generate(
                          2,
                          (index) => Container(
                            margin:
                                EdgeInsets.only(left: (15 * index).toDouble()),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '\$${walletBalanceProvider.walletBalance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showAddBalanceModal(context, userId);
                    },
                    child: Text('Add Balance'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Transaction history logic
                    },
                    child: Text(
                      'Transaction History',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
