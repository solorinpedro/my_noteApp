import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_noteapp/api_service.dart';
import 'package:my_noteapp/models/NoteModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel note;
  final Function(NoteModel) onSave;

  EditNoteScreen({required this.note, required this.onSave});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      final updatedNote = NoteModel(
        id: widget.note.id,
        title: _titleController.text,
        content: _contentController.text,
        userId: widget.note.userId,
      );

      try {
        final response = await ApiService().updateNote(
          widget.note.id,
          updatedNote.toJson(), // toJson returns Map<String, dynamic>
          token,
        );

        if (response.statusCode == 200) {
          widget.onSave(updatedNote);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update note')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating note: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
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
          ],
        ),
      ),
    );
  }
}
