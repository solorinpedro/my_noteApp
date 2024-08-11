import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_noteapp/api_service.dart';
import 'package:my_noteapp/models/UserModel.dart';
import '../flutter_secure_storage.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                try {
                  final user = UserModel(
                    id: '',
                    username: _usernameController.text,
                    passwordVersion: '',
                    password: _passwordController.text,
                  );

                  final response = await apiService.login(user);

                  if (response.statusCode == 200) {
                    final responseData = jsonDecode(response.body);
                    final token = responseData['token'];

                    if (token == null) {
                      throw Exception('Token is missing in response');
                    }

                    await authService.saveToken(token); // Usa AuthService para guardar el token
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login Successful!')),
                    );
                    Navigator.pushReplacementNamed(context, '/notes');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: ${response.reasonPhrase}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An error occurred: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text(
                "Don't have an account? Sign up",
                style: TextStyle(color: Color(0xFFE91E63)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
