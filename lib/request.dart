import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'shared_prefs.dart';

// const host = 'http://leonardo674.pythonanywhere.com';
const host = 'http://manishbhandari903.pythonanywhere.com';
// const host = 'http://10.0.2.2:8000/';

const apiURLS = {
  'getCSRF'   : '$host/api/user/getcsrf/',
  'login'     : '$host/api/user/login/',
  'logout'    : '$host/api/user/logout/',
  'register'  : '$host/api/user/register/',
};

class RequestHelper {
  static Future<String> getCSRFToken() async {
    String csrftoken = await getLocalData('CSRFToken') as String;
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'csrftoken=$csrftoken',
      'Content-Length': '0',
      'Accept': '*/*',
      'Connection': 'keep-alive',
    };
    final response = await http.post(Uri.parse(apiURLS['getCSRF']!), headers: headers);
    if (response.statusCode == 200) {
      // final jsonResponse = json.decode(response.body);
      final cookies = response.headers['set-cookie']!;
      final cookieList = cookies.split('; ');
      // Iterate through the cookieList to find the 'csrftoken' cookie
      for (final cookie in cookieList) {
        // Split each cookie into name and value
        final parts = cookie.split('=');
        if (parts.length == 2) {
          final name = parts[0];
          final value = parts[1];
          if (name == 'csrftoken') {
            csrftoken = value; // Return the value of the 'csrftoken' cookie
          }
        }
      }
      setLocalData({'CSRFToken': csrftoken});
    }
    else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}');
      }
    }
    if (kDebugMode) {
      print('CSRF Token => $csrftoken');
    }
    return csrftoken;
  }

  static Future<http.Response> sendGetRequest(String url, Map<String, String> headers) async {
    return http.get(Uri.parse(url), headers: headers);
  }

  static Future<http.Response> sendPostRequest(String url, Map<String, String> headers, Map<String, String> data) async {
    // String jsonBody = json.encode(data);
    return http.post(Uri.parse(url), headers: headers, body: data);
  }

// Add more request methods as needed (e.g., PUT, DELETE, etc.).
}

class Requests {
  Requests(){
    RequestHelper.getCSRFToken();
  }

  static Future<Map<String, dynamic>> login(Map<String, String> data) async{
    String csrf = await RequestHelper.getCSRFToken();
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'csrftoken=$csrf;',
      'X-CSRFToken': csrf,
      'Accept': '*/*',
      'Connection': 'keep-alive',
    };
    final response = await RequestHelper.sendPostRequest(apiURLS['login']!, headers, data);
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse["status"] == true) {
        setLocalData({'idToken': jsonResponse["data"]["idToken"]});
        setLocalData({'refreshToken': jsonResponse["data"]["refreshToken"]});
        setLocalData({'expiresIn': jsonResponse["data"]["expiresIn"]});
        setLocalData({'username': jsonResponse["data"]["username"]});
        setLocalData({'user': json.encode(jsonResponse["data"]["user"])});
      }
      // print("Success: ${jsonResponse["messages"]["info"]}");
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode} '
            '\nResponse Body:\n ${response.body}');
      }
    }
    return jsonResponse;
  }

  static Future<Map<String, dynamic>> logout() async{
    String csrf = await RequestHelper.getCSRFToken();
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'csrftoken=$csrf;',
      'X-CSRFToken': csrf,
      'Accept': '*/*',
      'Connection': 'keep-alive',
    };
    final response = await RequestHelper.sendPostRequest(apiURLS['logout']!, headers, {});
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse["status"] == true) {
        deleteLocalData('idToken');
        deleteLocalData('refreshToken');
        deleteLocalData('expiresIn');
        deleteLocalData('username');
      }
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode} '
            '\nResponse Body:\n ${response.body}');
      }
    }
    return jsonResponse;

  }

  static Future<Map<String, dynamic>> register(Map<String, String> data) async{
    String csrf = await RequestHelper.getCSRFToken();
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'csrftoken=$csrf;',
      'X-CSRFToken': csrf,
      'Accept': '*/*',
      'Connection': 'keep-alive',
    };
    final response = await RequestHelper.sendPostRequest(apiURLS['register']!, headers, data);
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    // Map<String, dynamic> jsonResponse = json.decode('{"status": true, "messages": {"success": "User \'testadmin6\' created successfully", "attributes": [{"level": 25, "message": "User \'testadmin6\' created successfully", "extra_tags": "extra tags value"}]}}');

    if (response.statusCode == 201) {
      if (jsonResponse["status"] == true) {
        if (kDebugMode) {
          print("User created Successfully: ${jsonResponse["messages"]["success"]}");
        }
      }
      // print("Success: ${jsonResponse["messages"]["info"]}");
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode} '
            '\nResponse Body:\n ${response.body}');
      }
    }
    return jsonResponse;
  }
}
