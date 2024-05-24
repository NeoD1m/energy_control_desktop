import 'dart:convert';
import 'package:energy_control_desktop/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/delete_file.dart';

class AllFilesPage extends StatefulWidget {
  @override
  _AllFilesPageState createState() => _AllFilesPageState();
}

class _AllFilesPageState extends State<AllFilesPage> {
  Future<List<dynamic>> fetchFiles() async {
    final response = await http.post(Uri.parse('$apiUrl/files/all'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load files');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Все документы'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No files found'));
          } else {
            final files = snapshot.data!;
            return ListView.separated(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text('ID: ${file['id']} - ${file['title']}'),
                  subtitle: Text('Type: ${file['type']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    onPressed: () async {
                      await deleteFile(file['id']);
                      setState(() {

                      });
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(); // This is the separator widget
              },
            );
          }
        },
      ),
    );
  }
}