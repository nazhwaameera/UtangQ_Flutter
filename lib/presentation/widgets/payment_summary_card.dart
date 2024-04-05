import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/payment_summary_provider.dart';
import 'package:utangq_app/presentation/widgets/horizontal_bar_widget_2.dart';

class PaymentSummaryCard extends StatelessWidget {
  final int userId;
  final List<ChartData2>? chartData;

  const PaymentSummaryCard({Key? key, required this.userId, this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PaymentSummaryProvider>(context, listen: false)
          .fetchPaymentSummary(userId);
    });
    return Consumer<PaymentSummaryProvider>(
        builder: (context, paymentSummaryProvider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle button press to show details
                      },
                      child: Text('Details'),
                    ),
                  ],
                ), // Adjust the height between the first row and the second row
                SingleStackedBarChart2(chartData: paymentSummaryProvider.chartData), // Chart in a single column
              ],
            ),
          );
        }
    );
  }

}