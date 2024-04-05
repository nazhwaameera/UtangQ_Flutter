import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/bill_recipient_amount_id_provider.dart';
import 'package:utangq_app/data/providers/bill_recipient_amount_provider.dart';
import 'package:utangq_app/data/providers/bill_recipient_provider.dart';
import 'package:utangq_app/data/providers/bill_summary_provider.dart';
import 'package:utangq_app/data/providers/friendship_list_provider.dart';
import 'package:utangq_app/data/providers/greeting_message_provider.dart';
import 'package:utangq_app/data/providers/payment_summary_provider.dart';
import 'package:utangq_app/data/providers/user_bills_provider.dart';
import 'package:utangq_app/data/providers/user_payments_provider.dart';
import 'package:utangq_app/data/providers/wallet_balance_provider.dart';
import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/login_user_adapter.dart';
import 'package:utangq_app/domain/utils/token_utils.dart';
import 'package:utangq_app/presentation/pages/login_page.dart';
import 'package:utangq_app/presentation/pages/register_page.dart';
import 'package:utangq_app/presentation/pages/users_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(LoginUserAdapter());

  await Hive.openBox(UsersRepository.boxName);

  final isEmpty = await isHiveBoxEmpty();
  int? userId = 0; // Initialize userId as nullable
  String? token;

  if (isEmpty) {
    // If the Hive box is empty, navigate to the login page
    print('Masuk isEmpty');
    runApp(MyApp(
      initialRoute: '/login',
      userId: 0,
    ));
  } else {
    print('Masuk isNotEmpty');
    // If the Hive box is not empty, retrieve the user ID and token
    userId = await getUserIdFromHive();
    token = await getTokenFromHive();
    final isTokenExpired = isExpired(token);
    print('Logged in with user id $userId');
    // Determine the initial route based on the token expiration
    final initialRoute = isTokenExpired ? '/login' : '/';
    runApp(MyApp(
      initialRoute: initialRoute,
      userId: userId ?? 0,
    ));
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final int userId;

  const MyApp({required this.initialRoute, required this.userId});

  @override
  Widget build(BuildContext context) {
    print('Logged in with user id: $userId');
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GreetingMessageProvider()),
          ChangeNotifierProvider(create: (_) => WalletBalanceProvider()),
          ChangeNotifierProvider(create: (_) => BillSummaryProvider()),
          ChangeNotifierProvider(create: (_) => PaymentSummaryProvider()),
          ChangeNotifierProvider(create: (_) => UserBillsProvider()),
          ChangeNotifierProvider(create: (_) => UserPaymentsProvider()),
          ChangeNotifierProvider(create: (_) => BillRecipientAmountProvider()),
          ChangeNotifierProvider(
              create: (_) => BillRecipientByBillIdProvider()),
          ChangeNotifierProvider(
              create: (_) => BillRecipientAmountIdProvider()),
          ChangeNotifierProvider(create: (_) => FriendshipListProvider()),
        ],
        child: MaterialApp(
          title: 'Your App',
          theme: ThemeData(
              // Your app theme
              ),
          initialRoute: initialRoute,
          routes: {
            '/': (context) => UserListPage(userId: userId),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage()
          },
        ));
  }
}
