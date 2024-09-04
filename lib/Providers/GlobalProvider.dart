import 'package:flutter/material.dart';
import 'package:csc_4130_iot_application/Handlers/NinjaApiService.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_utils.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_constants.dart';

class AppInfo with ChangeNotifier {
  List<Map<String, dynamic>> _devices = [];

  List<Map<String, dynamic>> get devices => _devices;

  Future<void> loadDevices() async {
    if (_devices.isNotEmpty) {
      return;
    }

    String? serverAddress = await SharedPrefrencesUtils().getString(keyServerAddress);
    if(serverAddress == null)
    {
      serverAddress = "https://iotcloudserver-production.up.railway.app";
    }
    NinjaApiService.setBase(serverAddress!);

    final fetchedDevices = await NinjaApiService.listDevices();
    _devices = fetchedDevices.map((device) {
      return {
        'id': device['device_name'],
        'image': 'assets/images/image1.jpg', // Placeholder image
        'title': device['device_name'], // Using device_name as the title
        'device_id': device['device_id'], // Adding the device_id as well
      };
    }).toList();

    notifyListeners();
  }
}
