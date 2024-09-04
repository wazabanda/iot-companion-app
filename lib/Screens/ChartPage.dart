import 'dart:async';
import 'package:csc_4130_iot_application/Handlers/NinjaApiService.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:csc_4130_iot_application/DataClasses/NumericalLogData.dart';
import 'package:csc_4130_iot_application/Constants/BrandColors.dart'; // Import BrandColors


// page will handle displaying reading that are fetched from the server
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
  int _selectedInterval = 30; // Default fetch interval in seconds

  @override
  void initState() {
    super.initState();
    fetchAndAppendLogs();  // Initial fetch
    _startTimer(_selectedInterval);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer(int interval) {
    _timer = Timer.periodic(Duration(seconds: interval), (timer) {
      fetchAndAppendLogs();
    });
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
        title: Text(
          deviceName,
          style: TextStyle(
            color: BrandColors.white, // AppBar text color
          ),
        ),
        backgroundColor: BrandColors.oxfordBlue, // AppBar background color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: [
                  Text(
                    "Update Interval: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: BrandColors.white, // Label color
                    ),
                  ),
                  SizedBox(width: 16),
                  DropdownButton<int>(
                    value: _selectedInterval,
                    items: [5, 10, 30, 60, 120, 300].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          '$value seconds',
                          style: TextStyle(color: BrandColors.white), // Dropdown text color
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedInterval = newValue;
                          _startTimer(_selectedInterval); // Restart the timer with the new interval
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            ...data.entries.map((entry) {
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: BrandColors.white, // Heading color
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle: TextStyle(color: BrandColors.white), // X-axis labels color
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: TextStyle(color: BrandColors.white), // Y-axis labels color
                      ),
                      title: ChartTitle(
                        text: 'Latest value: $latestValue',
                        textStyle: TextStyle(color: BrandColors.white), // Chart title color
                      ),
                      legend: Legend(
                        isVisible: true,
                        textStyle: TextStyle(color: BrandColors.white), // Legend text color
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<NumericalLogData, String>>[
                        LineSeries<NumericalLogData, String>(
                          dataSource: chartData,
                          xValueMapper: (NumericalLogData logData, _) => logData.time,
                          yValueMapper: (NumericalLogData logData, _) => logData.sales,
                          name: heading,
                          color: BrandColors.carrotOrange, // Line color
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(color: BrandColors.white), // Data label color
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
