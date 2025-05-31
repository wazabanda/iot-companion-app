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
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Your Devices',
          style: TextStyle(
            color: BrandColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: BrandColors.cardBackground,
      ),
      body: deviceProvider.devices.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: BrandColors.primary,
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              padding: EdgeInsets.all(20),
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: BrandColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              cardData['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: BrandColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cardData['title'],
                                  style: TextStyle(
                                    color: BrandColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
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
