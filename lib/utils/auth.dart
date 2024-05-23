import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../models/user.dart';

const String _userKey = 'user';

Future<void> saveUser(User user) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String userJson = jsonEncode(user.toJson());
  await prefs.setString(_userKey, userJson);
}

Future<User?> getUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString(_userKey);
  if (userJson != null) {
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return User.fromJson(userMap);
  }
  return null;
}

Future<void> removeUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_userKey);
}

Future<bool> userExists() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(_userKey);
}

Future<String> loginUser(String name, String password) async {
  String url = '$apiUrl/auth/loginAdmin';
  var response;
  try {
    response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'adminLogin': name,
        'adminPassword': password,
      }),
    );
  } catch (e) {}
  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);
    return responseBody["id"].toString();
  }
  if (response.statusCode == 401) {
    return "Invalid credentials";
  }
  if (response.statusCode == 500) {
    return "Server error";
  }
  return "Server error";
}
