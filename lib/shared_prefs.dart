import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> getLocalData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  dynamic data = prefs.getString(key);
  if (data == null) {
    return '';
  }
  return data;
}

Future<bool> setLocalData(Map<String, dynamic> data) async {
  final prefs = await SharedPreferences.getInstance();
  // Save data with a key
  data.forEach((key, value) {
    prefs.setString(key, value);
  });
  return true;
}

Future<void> deleteLocalData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key); // Delete a specific item, e.g., user token
}