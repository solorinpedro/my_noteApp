import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_service.dart';
import '../models/NoteModel.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<NoteModel> notes = [];
  final ApiService apiService = ApiService();
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadNotes();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserName = prefs.getString('username');
    if (savedUserName != null) {
      setState(() {
        userName = savedUserName;
      });
    }
  }


  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      try {
        final loadedNotes = await apiService.getNotes(token);
        setState(() {
          notes = loadedNotes;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load notes: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName != null ? '$userName\'s Notes' : 'My Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(child: Text('No notes available'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
            child: ListTile(
              title: Text(notes[index].title),
              subtitle: Text(notes[index].content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/editNote',
                        arguments: notes[index],
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('auth_token');

                      if (token != null) {
                        await apiService.deleteNote(
                          notes[index].id,
                          token,
                        );
                        setState(() {
                          notes.removeAt(index);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/editNote');
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
