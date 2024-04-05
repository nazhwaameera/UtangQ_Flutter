import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/bill_summary_provider.dart';
import 'package:utangq_app/presentation/widgets/horizontal_bar_widget.dart';

class BillSummaryCard extends StatelessWidget {
  final int userId;
  final List<ChartData>? chartData;

  const BillSummaryCard({Key? key, required this.userId, this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillSummaryProvider>(context, listen: false)
          .fetchBillSummary(userId);
    });
    return Consumer<BillSummaryProvider>(
      builder: (context, billSummaryProvider, _) {
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
                          'Bills Summary',
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
              SingleStackedBarChart(chartData: billSummaryProvider.chartData), // Chart in a single column
            ],
          ),
        );
      }
    );
  }

}

