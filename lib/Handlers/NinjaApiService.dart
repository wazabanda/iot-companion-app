import 'dart:convert';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_constants.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_utils.dart';
import 'package:http/http.dart' as http;

class NinjaApiService {
  static String baseUrl = 'https://your-api-url.com';
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

  static Future<void> _checkTokenValidity() async {
    if (authToken == null || tokenExpiry == null || DateTime.now().isAfter(tokenExpiry!)) {
      String? username = await SharedPrefrencesUtils().getString(keyUsername);
      String? password = await SharedPrefrencesUtils().getString(keyPassword);
      await login(username!, password!);
      print(authToken);
    }
  }
}
