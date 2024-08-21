import 'package:csc_4130_iot_application/DataClasses/NumericalLogData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NumericalChartPage extends StatefulWidget {
  final String id; // Add this line to accept a string id

  const NumericalChartPage({Key? key, required this.id}) : super(key: key); // Update constructor

  @override
  _NumericalChartPageState createState() => _NumericalChartPageState();
}

class _NumericalChartPageState extends State<NumericalChartPage> {
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

  void updateChartData(String heading, String timeStamp, double newValue) {
    setState(() {
      data[heading]!.add(NumericalLogData(timeStamp, newValue));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use widget.id to filter data or other logic as needed
    String pageId = widget.id; // Access the passed id

    return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion Flutter chart - $pageId'), // Display the id in the title or use it as needed
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
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
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
