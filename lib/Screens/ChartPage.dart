import 'dart:async';
import 'dart:convert'; // For jsonEncode
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:csc_4130_iot_application/DataClasses/NumericalLogData.dart';
import 'package:csc_4130_iot_application/Handlers/NinjaApiService.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:csc_4130_iot_application/Constants/BrandColors.dart'; // Import BrandColors
// import 'package:qr_code_scanner/qr_code_scanner.dart';


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

  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Key for the QR scanner
  // Barcode? result; // To store the scanned result
  // QRViewController? qrController; // Controller for QR view


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
    String wsUrl = 'ws://' + extractBaseUrlPart(baseUrl) + "/ws/devices/" + widget.id;
    
    print('Connecting to WebSocket: $wsUrl');
    
    // Initialize WebSocket
    channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    
    // Listen for WebSocket messages
    channel.stream.listen(
      (message) {
        print('WebSocket received: $message');
        // Handle incoming messages if needed
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );

    _startTimer(_selectedInterval);
  }

  @override
  void dispose() {
    _timer.cancel();
    print('Closing WebSocket connection');
    channel.sink.close();
    buttonNameController.dispose();
    // qrController?.dispose();// Dispose of controller
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
    print('Sending WebSocket message: ${jsonEncode(message)}');
    try {
      channel.sink.add(jsonEncode(message));
      print('Successfully sent pin toggle message for pin: $pin, new state: ${buttonStates[pin]}');
    } catch (e) {
      print('Failed to send WebSocket message: $e');
    }
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BrandColors.background,
        appBar: AppBar(
          backgroundColor: BrandColors.background,
          iconTheme: IconThemeData(color: BrandColors.textPrimary),
          title: Text(widget.name,
          style: TextStyle(
            color: BrandColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: "Charts"),
              Tab(text: "Controls"),
              Tab(text: "Settings"),
            ],
            labelColor: BrandColors.primary,
            unselectedLabelColor: BrandColors.textSecondary,
            indicatorColor: BrandColors.primary,
          ),
        ),
        body: TabBarView(
          children: [
            _buildChartTab(),
            _buildButtonsTab(),
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
          // Update Interval Selector
          Container(
            margin: EdgeInsets.fromLTRB(24, 24, 24, 16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: BrandColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chart Settings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: BrandColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.update,
                      color: BrandColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Update Interval:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: BrandColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: BrandColors.primary.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<int>(
                        value: _selectedInterval,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down, color: BrandColors.primary),
                        items: [5, 10, 30, 60, 120, 300].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value seconds',
                              style: TextStyle(
                                color: BrandColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
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
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Charts
          ...data.entries.map((entry) {
            final heading = entry.key;
            final chartData = entry.value;
            final latestValue = chartData.isNotEmpty ? chartData.last.sales.toStringAsFixed(2) : 'No Data';

            return Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: BrandColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              heading,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: BrandColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Real-time data',
                              style: TextStyle(
                                fontSize: 14,
                                color: BrandColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: BrandColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.show_chart,
                                size: 18,
                                color: BrandColors.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Latest: $latestValue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: BrandColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 20,
                    ),
                    child: SfCartesianChart(
                      margin: EdgeInsets.zero,
                      primaryXAxis: CategoryAxis(
                        labelStyle: TextStyle(color: BrandColors.textPrimary),
                        axisLine: AxisLine(color: BrandColors.textSecondary.withOpacity(0.3)),
                        majorGridLines: MajorGridLines(
                          color: BrandColors.textSecondary.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: TextStyle(color: BrandColors.textPrimary),
                        axisLine: AxisLine(color: BrandColors.textSecondary.withOpacity(0.3)),
                        majorGridLines: MajorGridLines(
                          color: BrandColors.textSecondary.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      plotAreaBorderColor: Colors.transparent,
                      legend: Legend(
                        isVisible: false,
                      ),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        color: BrandColors.primary,
                        textStyle: TextStyle(color: BrandColors.white),
                      ),
                      series: <CartesianSeries<NumericalLogData, String>>[
                        LineSeries<NumericalLogData, String>(
                          dataSource: chartData,
                          xValueMapper: (NumericalLogData logData, _) => logData.time,
                          yValueMapper: (NumericalLogData logData, _) => logData.sales,
                          name: heading,
                          color: BrandColors.primary,
                          width: 2.5,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            height: 8,
                            width: 8,
                            shape: DataMarkerType.circle,
                            borderWidth: 2,
                            color: BrandColors.primary,
                            borderColor: BrandColors.cardBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 24), // Bottom padding
        ],
      ),
    );
  }

  /*Widget _buildQRScannerTab() {
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
  }*/
/*
  // Callback function when the QR view is created
  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
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
  */
  Widget _buildButtonsTab() {
    return Container(
      color: BrandColors.background,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buttons.isEmpty
                  ? Center(
                      child: Text(
                        "No buttons available",
                        style: TextStyle(color: BrandColors.textSecondary),
                      ),
                    )
                  : GridView.builder(
                      itemCount: buttons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final button = buttons[index];
                        final pin = button['pin'];
                        final isActive = buttonStates[pin]!;

                        return Container(
                          decoration: BoxDecoration(
                            color: BrandColors.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => togglePin(pin),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isActive 
                                            ? BrandColors.secondary.withOpacity(0.1)
                                            : BrandColors.primary.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isActive ? Icons.power_settings_new : Icons.power_off,
                                        color: isActive 
                                            ? BrandColors.secondary
                                            : BrandColors.primary,
                                        size: 28,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      button['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: BrandColors.textPrimary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      isActive ? 'ON' : 'OFF',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isActive 
                                            ? BrandColors.secondary
                                            : BrandColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: BrandColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: buttonNameController,
                decoration: InputDecoration(
                  labelText: 'Enter button name to toggle',
                  prefixIcon: Icon(Icons.search, color: BrandColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: BrandColors.cardBackground,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                onSubmitted: (value) {
                  togglePinByName(value);
                  buttonNameController.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
