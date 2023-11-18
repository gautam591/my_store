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
  data.forEach((key, value) async {
    await prefs.setString(key, value);
  });
  return true;
}

Future<bool> deleteLocalData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key); // Delete a specific item, e.g., user token
  return true;
}

Future<bool> deleteAllLocalData({String flag = 'soft'}) async {
  final prefs = await SharedPreferences.getInstance();
  if(flag == 'hard'){
    await prefs.clear();
  }
  else{
    String csrfValue = prefs.getString('CSRFToken') ?? '';
    await prefs.clear();
    await prefs.setString('CSRFToken', csrfValue);
  }
  return true;
}