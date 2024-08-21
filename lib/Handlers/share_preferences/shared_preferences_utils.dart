import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesUtils {
  static final SharedPrefrencesUtils _singleton =
  SharedPrefrencesUtils._internal();

  factory SharedPrefrencesUtils() {
    return _singleton;
  }

  SharedPrefrencesUtils._internal();

  Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> setInt(String key, int value) async {
    return (await SharedPreferences.getInstance()).setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    return (await SharedPreferences.getInstance()).setDouble(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return (await SharedPreferences.getInstance()).setBool(key, value);
  }

  Future<bool> setString(String key, String value) async {
    return (await SharedPreferences.getInstance()).setString(key, value);
  }

  Future<int?> getInt(String key) async {
    return (await SharedPreferences.getInstance()).getInt(key);
  }

  Future<double?> getDouble(String key) async {
    return (await SharedPreferences.getInstance()).getDouble(key);
  }

  Future<bool?> getBool(String key) async {
    return (await SharedPreferences.getInstance()).getBool(key);
  }

  Future<String?> getString(String key) async {
    return (await SharedPreferences.getInstance()).getString(key);
  }
}