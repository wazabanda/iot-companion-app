import 'dart:async';
import 'package:csc_4130_iot_application/Handlers/NinjaApiService.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:csc_4130_iot_application/DataClasses/NumericalLogData.dart';

class NumericalChartPage extends StatefulWidget {
  final String id;
  final String name;

  const NumericalChartPage({Key? key, required this.id, required this.name}) : super(key: key);

  @override
  _NumericalChartPageState createState() => _NumericalChartPageState();
}

class _NumericalChartPageState extends State<NumericalChartPage> {
  Map<String, List<NumericalLogData>> data = {};
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchAndAppendLogs();  // Initial fetch
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      fetchAndAppendLogs();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchAndAppendLogs() async {
    try {
      final logs = await NinjaApiService.getNumericalLogs(widget.id);

      setState(() {
        for (var log in logs) {
          final String label = log['data_label'];
          final String timeStamp = log['date_time'];
          final double value = log['value'];

          if (!data.containsKey(label)) {
            data[label] = [];
          }

          // Check if this timestamp already exists in the list
          if (data[label]!.every((entry) => entry.time != timeStamp)) {
            data[label]!.add(NumericalLogData(timeStamp, value));
          }
        }
      });
    } catch (e) {
      print('Failed to fetch logs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String deviceName = widget.name;

    return Scaffold(
      appBar: AppBar(
        title: Text('$deviceName'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.entries.map((entry) {
            final heading = entry.key;
            final chartData = entry.value;
            final latestValue = chartData.isNotEmpty ? chartData.last.sales : 'No Data';

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
                        xValueMapper: (NumericalLogData logData, _) => logData.time,
                        yValueMapper: (NumericalLogData logData, _) => logData.sales,
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
