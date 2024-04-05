import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SingleStackedBarChart extends StatelessWidget {
  final List<ChartData> chartData;

  const SingleStackedBarChart({Key? key, required this.chartData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150.0,
        child: SfCartesianChart(
          legend: Legend(isVisible: true, isResponsive: true, position: LegendPosition.bottom),
          primaryXAxis: CategoryAxis(),
          series: <CartesianSeries>[
            StackedBar100Series<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              width: 0.1,
              name: 'Unassigned',
            ),
            StackedBar100Series<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y2,
              width: 0.1,
              name: 'Pending',
            ),
            StackedBar100Series<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y3,
              width: 0.1,
              name: 'Rejected',
            ),
            StackedBar100Series<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y4,
              width: 0.1,
              name: 'Accepted',
            ),
            StackedBar100Series<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y5,
              width: 0.1,
              name: 'Awaiting',
            ),
            StackedBar100Series<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y6,
              width: 0.1,
              name: 'Paid',
            )
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String x;
  final num y;
  final num y2;
  final num y3;
  final num y4;
  final num y5;
  final num y6;

  ChartData(this.x, this.y, this.y2, this.y3, this.y4, this.y5, this.y6);
}
