import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> deleteFile(int fileId) async {
  final url = Uri.parse('http://neodim.fun/files');

  final payload = {
    "adminLogin": "admin",
    "adminPassword": "admin",
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