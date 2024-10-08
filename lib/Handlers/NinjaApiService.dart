import 'dart:convert';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_constants.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_utils.dart';
import 'package:http/http.dart' as http;


// The purpose of this class is to provid a handler that will be used to interact with the api on the deployed cloud server.
class NinjaApiService {
  static String baseUrl = 'https://iotcloudserver-production.up.railway.app';
  static String? authToken;
  static DateTime? tokenExpiry;

  static void setBase(String newBase) {
    baseUrl = newBase;
  }

  static void setAuthToken(String token, DateTime expiry) {
    authToken = token;
    tokenExpiry = expiry;
  }

  static Future<http.Response> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/login').replace(queryParameters: {
      'username': username,
      'password': password,
    });

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      final expires = DateTime.parse(data['expires']);
      setAuthToken(token, expires);
      return response;
    } else {
      print(response.body);
      throw Exception('Failed to login');
    }
  }

  static Future<List<dynamic>> listDevices() async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/devices');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load devices');
    }
  }

  static Future<Map<String, dynamic>> getDevice(String uuid) async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/device/$uuid');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load device');
    }
  }

  static Future<List<dynamic>> getNumericalLogs(String uuid) async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/device_logs/$uuid');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load numerical logs');
    }
  }

  static Future<void> addNumericalLog(String uuid, List<Map<String, dynamic>> logs) async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/numerical-logs/$uuid');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({'logs': logs}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add numerical log');
    }
  }

  static Future<List<dynamic>> getLocationData(String uuid) async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/location-data/$uuid');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load location data');
    }
  }
  static Future<List<Map<String, dynamic>>> getDevicePins(String uuid) async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/pins/$uuid');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load pins');
    }
  }

  static Future<void> addLocationData(String uuid, Map<String, dynamic> locationData) async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/location-data/$uuid');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(locationData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add location data');
    }
  }


  // New API methods for inventory routes
  static Future<List<Map<String, dynamic>>> getInventoryEntry(String uuid) async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/inventory/entry/$uuid');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load inventory entry');
    }
  }

  static Future<List<Map<String, dynamic>>> getInventoryLogs(String id) async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/inventory/logs/$id');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load inventory logs');
    }
  }

  static Future<void> createInventoryLog(String id, Map<String, dynamic> logData) async {
    await _checkTokenValidity();
    final url = Uri.parse('$baseUrl/api/core/inventory/logs/$id');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(logData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create inventory log');
    }
  }



  static Future<void> _checkTokenValidity() async {

    if (authToken == null || tokenExpiry == null || DateTime.now().isAfter(tokenExpiry!)) {
      String? username = await SharedPrefrencesUtils().getString(keyUsername);
      String? password = await SharedPrefrencesUtils().getString(keyPassword);
      if(username == null)
        {
          username="waza";
        }
      if(password == null)
        {
          password = "7test@123";
        }
      await login(username!, password!);
      print(authToken);
    }
  }
}
