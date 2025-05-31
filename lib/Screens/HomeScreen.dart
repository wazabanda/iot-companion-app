import 'package:csc_4130_iot_application/Handlers/NinjaApiService.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_constants.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_utils.dart';
import 'package:csc_4130_iot_application/Providers/GlobalProvider.dart';
import 'package:csc_4130_iot_application/Screens/ChartPage.dart';
import 'package:csc_4130_iot_application/Screens/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csc_4130_iot_application/Constants/BrandColors.dart'; // Import BrandColors

// this screen will display all devices registered for the logged in user on the web app. 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DeviceListScreen(),  // We'll extract the current device list into this widget
    SettingsScreen(),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: BrandColors.cardBackground,
          selectedItemColor: BrandColors.primary,
          unselectedItemColor: BrandColors.textSecondary,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.devices),
              label: 'Devices',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// Extract the device list into a separate widget
class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<AppInfo>(context, listen: false).loadDevices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<AppInfo>(context);
    final filteredDevices = deviceProvider.devices.where((device) {
      return device['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        // Search Header
        Container(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
          decoration: BoxDecoration(
            color: BrandColors.cardBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Devices',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: BrandColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: BrandColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: BrandColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search devices...',
                      hintStyle: TextStyle(color: BrandColors.textSecondary),
                      prefixIcon: Icon(Icons.search, color: BrandColors.primary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Device List
        Expanded(
          child: RefreshIndicator(
            color: BrandColors.primary,
            backgroundColor: BrandColors.cardBackground,
            onRefresh: () async {
              await Provider.of<AppInfo>(context, listen: false).loadDevices();
            },
            child: deviceProvider.devices.isEmpty
                ? ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.devices_other,
                              size: 64,
                              color: BrandColors.textSecondary.withOpacity(0.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No devices found',
                              style: TextStyle(
                                color: BrandColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pull down to refresh',
                              style: TextStyle(
                                color: BrandColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: filteredDevices.length,
                    itemBuilder: (context, index) {
                      final device = filteredDevices[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
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
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NumericalChartPage(
                                    id: device['device_id'],
                                    name: device['id'],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: BrandColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.devices,
                                        color: BrandColors.primary,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          device['title'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: BrandColors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Device ID: ${device['device_id']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: BrandColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: BrandColors.primary,
                                    size: 24,
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
      ],
    );
  }
}
