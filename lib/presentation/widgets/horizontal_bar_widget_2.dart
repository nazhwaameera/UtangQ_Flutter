import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SingleStackedBarChart2 extends StatelessWidget {
  final List<ChartData2> chartData;

  const SingleStackedBarChart2({Key? key, required this.chartData})
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
            StackedBar100Series<ChartData2, String>(
              dataSource: chartData,
              xValueMapper: (ChartData2 data, _) => data.x,
              yValueMapper: (ChartData2 data, _) => data.y,
              width: 0.1,
              name: 'Pending',
            ),
            StackedBar100Series<ChartData2, String>(
              dataSource: chartData,
              xValueMapper: (ChartData2 data, _) => data.x,
              yValueMapper: (ChartData2 data, _) => data.y2,
              width: 0.1,
              name: 'Accepted',
            ),
            StackedBar100Series<ChartData2, String>(
              dataSource: chartData,
              xValueMapper: (ChartData2 data, _) => data.x,
              yValueMapper: (ChartData2 data, _) => data.y3,
              width: 0.1,
              name: 'Awaiting',
            ),
            StackedBar100Series<ChartData2, String>(
              dataSource: chartData,
              xValueMapper: (ChartData2 data, _) => data.x,
              yValueMapper: (ChartData2 data, _) => data.y4,
              width: 0.1,
              name: 'Paid',
            )
          ],
        ),
      ),
    );
  }
}

class ChartData2 {
  final String x;
  final num y;
  final num y2;
  final num y3;
  final num y4;

  ChartData2(this.x, this.y, this.y2, this.y3, this.y4);
}
