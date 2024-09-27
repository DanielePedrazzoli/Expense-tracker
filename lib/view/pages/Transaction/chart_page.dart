import 'package:expense_tracker/models/char/chart_data.dart';
import 'package:expense_tracker/models/char/chart_option.dart';
import 'package:expense_tracker/view/Components/chart/inspect_month_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChartPage extends StatefulWidget {
  final ChartOption option;
  final List<ChartData> data;

  const ChartPage({super.key, required this.data, required this.option});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InspectMonthChart(
        data: widget.data,
        option: widget.option,
      ),
    );
  }
}
