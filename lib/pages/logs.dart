import 'package:energy_control_desktop/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';
import '../utils/auth.dart';

class LogsPage extends StatefulWidget {
  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<dynamic> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    final url = Uri.parse('$apiUrl/logs');
    User? user = await getUser();
    final body = jsonEncode({
      "adminLogin": user?.login,
      "adminPassword": user?.password
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          _logs = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load logs');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Логи'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
          ? const Center(child: Text('No logs available'))
          : ListView.builder(
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          final log = _logs[index];
          return ListTile(
            title: Text(log['action']),
            subtitle: Text(
                'User ID: ${log['user_id']}, File ID: ${log['file_id']}'),
            trailing: Text(log['timestamp']),
          );
        },
      ),
    );
  }
}