import 'dart:async';
import 'dart:convert'; // For jsonEncode
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:csc_4130_iot_application/DataClasses/NumericalLogData.dart';
import 'package:csc_4130_iot_application/Handlers/NinjaApiService.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:csc_4130_iot_application/Constants/BrandColors.dart'; // Import BrandColors
import 'package:qr_code_scanner/qr_code_scanner.dart';


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
  int _selectedInterval = 30;
  List<Map<String, dynamic>> buttons = [];
  Map<int, bool> buttonStates = {}; // Map to track button states
  late WebSocketChannel channel;
  TextEditingController buttonNameController = TextEditingController(); // Controller for the text input

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Key for the QR scanner
  Barcode? result; // To store the scanned result
  QRViewController? qrController; // Controller for QR view


  String extractBaseUrlPart(String baseUrl) {
    if (baseUrl.startsWith('https://')) {
      return baseUrl.substring('https://'.length);
    } else if (baseUrl.startsWith('http://')) {
      return baseUrl.substring('http://'.length);
    } else {
      return baseUrl;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndAppendLogs();
    fetchButtons();
    String baseUrl = NinjaApiService.baseUrl;

    // Initialize WebSocket
    channel = WebSocketChannel.connect(
      Uri.parse('ws://' + extractBaseUrlPart(baseUrl) + "/ws/devices/" + widget.id),
    );

    _startTimer(_selectedInterval);
  }

  @override
  void dispose() {
    _timer.cancel();
    channel.sink.close(); // Close WebSocket connection
    buttonNameController.dispose();
    qrController?.dispose();// Dispose of controller
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

  Future<void> fetchButtons() async {
    try {
      final buttonsFromApi = await NinjaApiService.getDevicePins(widget.id);
      setState(() {
        buttons = buttonsFromApi;
        for (var button in buttons) {
          buttonStates[button['pin']] = false; // Initialize button states as 'OFF'
        }
      });
    } catch (e) {
      print('Failed to fetch buttons: $e');
    }
  }

  void togglePin(int pin) {
    // Toggle the button state
    setState(() {
      buttonStates[pin] = !buttonStates[pin]!;
    });

    // Prepare WebSocket message
    final message = {
      "type": "pin.message",
      "message": "Toggle pin",
      "pin": pin,
      "state": buttonStates[pin]
    };

    // Send WebSocket message
    channel.sink.add(jsonEncode(message)); // Convert map to JSON string

    print("Toggling pin: $pin, State: ${buttonStates[pin]}");
  }

  // Function to toggle pin based on button name
  void togglePinByName(String buttonName) {

    final button = buttons.firstWhere(
          (button) => button['name'].toLowerCase() == buttonName.toLowerCase(),
      orElse: () => {},
    );

    if (button.isNotEmpty) {
      togglePin(button['pin']);
      print("toggled: $buttonName");
    } else {
      print("Button with name '$buttonName' not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    String deviceName = widget.name;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            deviceName,
            style: TextStyle(
              color: BrandColors.white,
            ),
          ),
          backgroundColor: BrandColors.oxfordBlue,
          bottom: TabBar(
            tabs: [
              Tab(text: "Charts"),
              Tab(text: "Buttons"),
              Tab(text: "QR Scanner"), // New QR Scanner tab
            ],
            labelStyle: TextStyle(color: BrandColors.antiFlashWhite),
          ),
        ),
        body: TabBarView(
          children: [
            _buildChartTab(),
            _buildButtonsTab(),
            _buildQRScannerTab(), // Add the new QR scanner tab here
          ],
        ),
      ),
    );
  }

  Widget _buildChartTab() {
    return SingleChildScrollView(
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
                    color: BrandColors.white,
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
                        style: TextStyle(color: BrandColors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedInterval = newValue;
                        _startTimer(_selectedInterval);
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
                      color: BrandColors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelStyle: TextStyle(color: BrandColors.white),
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: TextStyle(color: BrandColors.white),
                    ),
                    title: ChartTitle(
                      text: 'Latest value: $latestValue',
                      textStyle: TextStyle(color: BrandColors.white),
                    ),
                    legend: Legend(
                      isVisible: true,
                      textStyle: TextStyle(color: BrandColors.white),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<NumericalLogData, String>>[
                      LineSeries<NumericalLogData, String>(
                        dataSource: chartData,
                        xValueMapper: (NumericalLogData logData, _) => logData.time,
                        yValueMapper: (NumericalLogData logData, _) => logData.sales,
                        name: heading,
                        color: BrandColors.carrotOrange,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(color: BrandColors.white),
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
    );
  }

  Widget _buildQRScannerTab() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: (result != null)
                    ? Text('Scanned QR Code: ${result!.code}')
                    : Text('Scan a QR code to get its value'),
              ),
              const SizedBox(height: 16), // Space between text and button
              ElevatedButton(
                onPressed: result != null
                    ? () {
                  _confirmAndSendQRCode(result!.code!);
                }
                    : null, // Disable the button if no QR code is scanned
                style: ElevatedButton.styleFrom(
                  backgroundColor: result != null ? Colors.green : Colors.grey,
                ),
                child: Text('Confirm & Send QR Code'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Callback function when the QR view is created
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.qrController = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData; // Store the scanned result
      });

      // Optionally, you can handle the QR code immediately after scanning
      _handleScannedQRCode(result!.code!);
    });
  }

  // Function to handle the scanned QR code
  void _handleScannedQRCode(String code) {
    print("Scanned QR Code: $code");
    // You can perform additional processing with the scanned code here
  }

  // Function to confirm and send the scanned QR code value
  void _confirmAndSendQRCode(String code) {
    // Implement the logic for sending the QR code value here
    print('Sending QR Code: $code');
    // You can call a function from your API service to handle the sending, or use other methods as needed
  }
  Widget _buildButtonsTab() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buttons.isEmpty
                ? Center(
              child: Text(
                "No buttons available",
                style: TextStyle(color: BrandColors.white),
              ),
            )
                : GridView.builder(
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2, // Control button size
              ),
              itemBuilder: (context, index) {
                final button = buttons[index];
                final pin = button['pin'];

                return ElevatedButton(
                  onPressed: () {
                    togglePin(pin);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    buttonStates[pin]! ? Colors.green : Colors.red,
                    textStyle: TextStyle(color: BrandColors.white),
                  ),
                  child: Text(button['name']),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: buttonNameController,
            decoration: InputDecoration(
              labelText: 'Enter button name to toggle',
              labelStyle: TextStyle(color: BrandColors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: BrandColors.oxfordBlue,
            ),
            style: TextStyle(color: BrandColors.antiFlashWhite),
            onSubmitted: (value) {
              togglePinByName(value);
              buttonNameController.clear(); // Clear input after submission
            },
          ),
        ),
      ],
    );
  }
}
