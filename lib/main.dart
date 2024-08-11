import 'package:flutter/material.dart';
import 'package:my_noteapp/ui/AddNoteScreen.dart';
import 'package:my_noteapp/ui/EditNoteScreen.dart';
import 'package:my_noteapp/ui/LoginScreen.dart';
import 'package:my_noteapp/ui/SignUpScreen.dart';
import 'package:my_noteapp/ui/NotesScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/NoteModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? authToken;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    setState(() {
      authToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primaryColor: Color(0xFFE91E63), // Rosa
        hintColor: Color(0xFF00BCD4),  // Azul celeste
        scaffoldBackgroundColor: Color(0xFFFCE4EC), // Fondo rosa pálido
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF333333)), // Texto gris oscuro
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFE91E63), // Botones rosados
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFFE91E63), // AppBar rosada
        ),
      ),
      initialRoute: authToken == null ? '/login' : '/notes',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/notes': (context) => NotesScreen(),
        '/addNote': (context) => AddNoteScreen(), // Register the AddNoteScreen route
        '/editNote': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final note = args['note'] as NoteModel;
          final onSave = args['onSave'] as Function(NoteModel);

          return EditNoteScreen(
            note: note,
            onSave: onSave,
          );
        },
      },
    );
  }
}
