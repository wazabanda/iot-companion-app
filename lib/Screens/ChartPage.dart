import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  // Sample data in the format you provided
  Map<String, List<NumericalLogData>> data = {
    'Temperature': [
      NumericalLogData('2023-01-01', 35),
      NumericalLogData('2023-01-02', 28),
      NumericalLogData('2023-01-03', 34),
      NumericalLogData('2023-01-04', 32),
      NumericalLogData('2023-01-05', 40),
    ],
    'Heading 2': [
      NumericalLogData('2023-01-01', 20),
      NumericalLogData('2023-01-02', 15),
      NumericalLogData('2023-01-03', 25),
      NumericalLogData('2023-01-04', 22),
      NumericalLogData('2023-01-05', 18),
    ],
    'Heading 3': [
      NumericalLogData('2023-01-01', 20),
      NumericalLogData('2023-01-02', 15),
      NumericalLogData('2023-01-03', 25),
      NumericalLogData('2023-01-04', 22),
      NumericalLogData('2023-01-05', 18),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter chart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.entries.map((entry) {
            final heading = entry.key;
            final chartData = entry.value;
            final latestValue = chartData.last.sales;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Text(
                    heading,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: 'Latest value: $latestValue'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<NumericalLogData, String>>[
                      LineSeries<NumericalLogData, String>(
                        dataSource: chartData,
                        xValueMapper: (NumericalLogData sales, _) => sales.time,
                        yValueMapper: (NumericalLogData sales, _) => sales.sales,
                        name: heading,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

