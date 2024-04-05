import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/greeting_message_provider.dart';
import 'package:utangq_app/data/providers/wallet_balance_provider.dart';
import 'package:utangq_app/presentation/pages/manage_bill_page.dart';
import 'package:utangq_app/presentation/pages/manage_friendship.dart';
import 'package:utangq_app/presentation/pages/manage_payment_page.dart';
import 'package:utangq_app/presentation/widgets/floating_button.dart';
import 'package:utangq_app/presentation/widgets/menu_card.dart';
import 'package:utangq_app/presentation/widgets/modal_widget.dart';
import 'package:utangq_app/presentation/widgets/wallet_card.dart';
import 'package:utangq_app/presentation/widgets/welcome_card.dart';

class UserListPage extends StatefulWidget {
  final int userId;
  // Constructor to accept userId
  const UserListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late GreetingMessageProvider _greetingMessageProvider;

  @override
  void initState() {
    super.initState();
    _greetingMessageProvider = GreetingMessageProvider();
    _greetingMessageProvider.getGreetingMessage(widget.userId);
    print('Process running for user id ${_greetingMessageProvider.userId}');
  }


  Future<void> _refreshData() async {
    await Provider.of<WalletBalanceProvider>(context, listen: false)
        .updateWalletBalance(widget.userId!);
    print('Process running for user id ${_greetingMessageProvider.userId}');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GreetingMessageProvider>(context, listen: false)
          .getGreetingMessage(widget.userId!);
    });
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: Consumer<GreetingMessageProvider>(
              builder: (context, greetingMessageProvider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton(
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              "asset/images/logo.jpg",
                              width: 50,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Add some spacing between icon and username
                          Text(
                            greetingMessageProvider.username,
                            // Replace 'Username' with the actual username
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                      onSelected: (value) {
                        if (value == "profile") {
                          // Add desired output for profile
                        } else if (value == "logout") {
                          showSimpleModalDialog(
                              context, 'Are you sure you want to logout?');
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          value: "profile",
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.account_circle),
                              ),
                              const Text(
                                'Profile',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: "logout",
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.logout),
                              ),
                              const Text(
                                'Logout',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<GreetingMessageProvider>(
        builder: (context, greetingMessageProvider, _) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: [
                WelcomeCard(message: greetingMessageProvider.greetingMessage ?? 'Loading...'),
                Consumer<WalletBalanceProvider>(
                  builder: (context, walletProvider, _) {
                    return WalletCard(userId: greetingMessageProvider.userId);
                  },
                ),
                GridView.count(
                    crossAxisCount: 2,
                    // 2 columns
                    shrinkWrap: true,
                    // Wrap content inside ListView
                    physics: NeverScrollableScrollPhysics(),
                    // Disable GridView scrolling
                    children: [
                      SquareCardMenu(
                        icon: Icons.payments,
                        description: 'Manage Payment',
                        iconColor: Color(0xFF846AFF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ManagePaymentPage(userId: greetingMessageProvider.userId,)),
                          );
                        },
                      ),
                      SquareCardMenu(
                        icon: Icons.receipt,
                        description: 'Manage Bills',
                        iconColor: Colors.amber,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ManageBillPage(userId: greetingMessageProvider.userId,)),
                          );
                        },
                      ),
                      SquareCardMenu(
                        icon: Icons.people,
                        description: 'Friendship List',
                        iconColor: Colors.purpleAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ManageFriendshipPage(userId: greetingMessageProvider.userId,)),
                          );
                        },
                      ),
                      SquareCardMenu(
                        icon: Icons.bar_chart,
                        description: 'Reports',
                        iconColor: Color(0xFF755EE8),
                        onTap: () {
                          // Add navigation logic here
                        },
                      ),
                    ])
              ],
            ),
          );
        }
      ),
      floatingActionButton: Consumer<GreetingMessageProvider>(
        builder: (context, greetingMessageProvider, _) {
          return FloatingButton(userId: greetingMessageProvider.userId);
        },
      ),
    );
  }
}
