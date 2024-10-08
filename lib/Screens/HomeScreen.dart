import 'package:csc_4130_iot_application/Handlers/NinjaApiService.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_constants.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_utils.dart';
import 'package:csc_4130_iot_application/Providers/GlobalProvider.dart';
import 'package:csc_4130_iot_application/Screens/ChartPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csc_4130_iot_application/Constants/BrandColors.dart'; // Import BrandColors

// this screen will display all devices registered for the logged in user on the web app. 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<AppInfo>(context, listen: false).loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<AppInfo>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Devices',
          style: TextStyle(
            color: BrandColors.white,  // Use brand color for text
          ),
        ),
        backgroundColor: BrandColors.oxfordBlue, // Set app bar color
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
                borderRadius: BorderRadius.circular(12), // Use a consistent border radius
              ),
              color: BrandColors.carrotOrange,  // Set card background color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12), // Match card border radius
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
                        color: BrandColors.white,  // Use brand color for text
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
