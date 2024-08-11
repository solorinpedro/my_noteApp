import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/NoteModel.dart';
import 'models/UserModel.dart';

class ApiService {
  final String baseUrl = 'http://192.168.100.8:3000';

  Future<http.Response> signUp(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> login(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': user.username,
        'password': user.password,
      }),
    );
    return response;
  }

  Future<http.Response> createNote(Map<String, String> data,  dynamic token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/note'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<List<NoteModel>> getNotes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/note'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => NoteModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }


  Future<http.Response> updateNote(String noteId, Map<String, dynamic> data,
      String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/note/$noteId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> deleteNote(String noteId, String token) async {
    final url = '$baseUrl/note/$noteId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }
}