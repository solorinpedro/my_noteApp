import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_noteapp/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  Future<void> _addNote() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token is null');
      }
      final response = await apiService.createNote({
        'title': _titleController.text,
        'content': _contentController.text,
      }, token);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData != null && responseData is Map<String, dynamic>) {
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to create note: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 6,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addNote,
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
