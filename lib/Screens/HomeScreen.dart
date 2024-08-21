import 'package:csc_4130_iot_application/Handlers/NinjaApiService.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_constants.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_utils.dart';
import 'package:csc_4130_iot_application/Providers/GlobalProvider.dart';
import 'package:csc_4130_iot_application/Screens/ChartPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();
    // loadDevices();
    // Globalprovider
    Provider.of<AppInfo>(context, listen: false).loadDevices();
  }

  // Asynchronous method to load saved settings
  //   Future<void> loadDevices() async {
  //
  //     String? serverAddress = await SharedPrefrencesUtils().getString(keyServerAddress);
  //     NinjaApiService.setBase(serverAddress!);
  //     final devices = await NinjaApiService.listDevices();
  //     for (var device in devices) {
  //       _cardData.add({
  //         'id': device['device_name'],
  //         'image': 'assets/images/image1.jpg', // Placeholder image
  //         'title': device['device_name'], // Using device_name as the title
  //         'device_id': device['device_id'], // Adding the device_id as well
  //       });
  //     }
  //     setState(() {
  //
  //     });
  //   }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<AppInfo>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Devices'),
      ),
      body: deviceProvider.devices.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        padding: EdgeInsets.all(16),
        itemCount: deviceProvider.devices.length,
        itemBuilder: (context, index) {
          final cardData = deviceProvider.devices[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NumericalChartPage(
                    id: cardData['device_id'],
                    name: cardData['id'],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Image.asset(
                        cardData['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      cardData['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

