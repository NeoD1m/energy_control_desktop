import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:desktop_drop/desktop_drop.dart';

import '../main.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Uint8List? uploadedFile;
  String? fileName;
  String? fileType;
  String fileTitle = '';

  final List<String> fileTypes = ['news', 'doc', 'info'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Загрузка документа'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Название документа', labelStyle: TextStyle(fontSize: 25),),
              onChanged: (value) {
                setState(() {
                  fileTitle = value;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              hint: Text('Выберите тип документа',style: TextStyle(fontSize: 25),),
              value: fileType,
              onChanged: (value) {
                setState(() {
                  fileType = value;
                });
              },
              items: fileTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropTarget(
              onDragDone: (details) async {
                if (details.files.isNotEmpty) {
                  final file = details.files.first;
                  final bytes = await file.readAsBytes();
                  setState(() {
                    uploadedFile = bytes;
                    fileName = file.name;
                  });
                }
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    fileName ?? 'Перетащите ваш файл сюда',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (uploadedFile != null && fileType != null && fileTitle.isNotEmpty) {
                  _uploadFile();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Заполните все поля')),
                  );
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 20, bottom: 20),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: Text('Загрузить',style: TextStyle(fontSize: 25),),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadFile() async {
    var uri = Uri.parse('$apiUrl/files/upload');
    var request = http.MultipartRequest('POST', uri);

    // TODO: Fill in admin login and password
    request.fields['adminLogin'] = 'admin';
    request.fields['adminPassword'] = 'admin';
    request.fields['title'] = fileTitle;
    request.fields['type'] = fileType!;

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      uploadedFile!,
      filename: fileName,
    ));

    request.headers['Content-Type'] = 'multipart/form-data';

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Файл загружен удачно')),
      );
      // Clear fields after successful upload
      setState(() {
        uploadedFile = null;
        fileName = null;
        fileType = null;
        fileTitle = '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки')),
      );
    }
  }
}