import 'package:expense_tracker/models/char/chart_data.dart';
import 'package:expense_tracker/models/char/chart_option.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InspectMonthChart extends StatelessWidget {
  final ChartOption option;
  final List<ChartData> data;

  const InspectMonthChart({super.key, required this.data, required this.option});

  List<double> _generateLineChartData() {
    List<double> total = [];
    var sum = 0.0;

    for (ChartData dayData in data) {
      sum += dayData.total;
      total.add(sum);
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, enablePanning: true),
      trackballBehavior: TrackballBehavior(enable: true),
      primaryXAxis: NumericAxis(
        interval: 1,
        minimum: 1,
        maximum: data.length.toDouble(),
        numberFormat: NumberFormat.compact(),
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.compact(),
      ),
      axes: [
        if (option.showLineChart)
          NumericAxis(
            numberFormat: NumberFormat.compact(),
            name: 'yAxis',
            opposedPosition: true,
          ),
      ],
      series: <CartesianSeries>[
        if (option.showCandlerChart)
          CandleSeries<ChartData, int>(
            animationDuration: 200,
            name: "Guadagni-Perdite",
            enableTooltip: true,
            enableSolidCandles: true,
            dataSource: data,
            xValueMapper: (ChartData data, index) {
              return data.day;
            },
            highValueMapper: (ChartData data, _) => data.income,
            lowValueMapper: (ChartData data, _) => -data.expense,
            openValueMapper: (ChartData data, _) => 0,
            closeValueMapper: (ChartData data, _) => data.total,
            pointColorMapper: (ChartData data, index) {
              if (data.total > 0) return const Color.fromARGB(40, 0, 255, 8);
              if (data.total == 0) return const Color.fromARGB(255, 60, 60, 60);
              return const Color.fromARGB(103, 156, 26, 17);
            },
          ),
        if (option.showLineChart)
          LineSeries<double, int>(
            animationDuration: 500,
            name: "Totale",
            enableTooltip: true,
            width: 2,
            yAxisName: 'yAxis',
            dataSource: _generateLineChartData(),
            yValueMapper: (double value, int index) => value,
            xValueMapper: (double value, int index) => index + 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
      ],
    );
  }
}
