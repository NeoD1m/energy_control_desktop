import 'dart:convert';
import 'package:energy_control_desktop/main.dart';
import 'package:energy_control_desktop/utils/auth.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

Future<void> deleteFile(int fileId) async {
  final url = Uri.parse('$apiUrl/files');

  User? user = await getUser();
  final payload = {
    "adminLogin": user!.login,
    "adminPassword": user.login,
    "fileId": fileId,
  };
  final response = await http.delete(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(payload),
  );
  if (response.statusCode == 200) {
    print('File deleted successfully');
  } else {
    print('Failed to delete file: ${response.statusCode}');
  }
}