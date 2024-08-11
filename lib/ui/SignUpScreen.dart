import 'package:flutter/material.dart';
import '../api_service.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_usernameController.text.isEmpty ||
                    _passwordController.text.isEmpty ||
                    _confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                if (_passwordController.text == _confirmPasswordController.text) {
                  try {
                    final response = await apiService.signUp({
                      'username': _usernameController.text,
                      'password': _passwordController.text,
                    });

                    if (response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sign Up Successful!')),
                      );
                      Navigator.pushReplacementNamed(context, '/login');
                    } else if (response.statusCode == 409) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User already exists')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sign Up failed: ${response.reasonPhrase}')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}