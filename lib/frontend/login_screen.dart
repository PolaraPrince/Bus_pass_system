import 'package:bus_pass_system/frontend/user_model.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'user_profile_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final Db database;

  LoginScreen({required this.database});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            // Text field for password.
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final username = emailController.text;
                final password = passwordController.text;

                loginUser(username, password).then((user) {
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(user: user),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Login Failed'),
                        content: Text('Invalid username or password.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                });
              },
              child: Text('Login'),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(database: database),
                  ),
                );
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> loginUser(String email, String password) async {
    final usersCollection = database.collection('users');
    final user = await usersCollection.findOne({
      'email': email,
      'password': password,
    });

    if (user != null) {
      return User(
        id: user['_id'].toString(),
        username: user['username'],
        email: user['email'],
        passwordHash: user['password'],
      );
    } else {
      return null;
    }
  }
}
