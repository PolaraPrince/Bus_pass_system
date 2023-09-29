import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bus_pass_system/frontend/user_model.dart';
import 'signup_screen.dart';
import 'user_profile_screen.dart';

class LoginScreen extends StatelessWidget {
  final Db database;

  LoginScreen({super.key, required this.database});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 120, 118, 212),
      ),
      backgroundColor: const Color.fromARGB(255, 39, 135, 135),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    "assets/Images/Login_Image.png",
                    fit: BoxFit.cover,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final username = emailController.text;
                      final password = passwordController.text;

                      loginUser(username, password).then((user) {
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserProfileScreen(user: user),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Failed'),
                              content:
                                  const Text('Invalid username or password.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 14, 8, 0),
                      // Change the button color
                    ),
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignUpScreen(database: database),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      final id = user['id'] ?? '';
      final username = user['username'] ?? '';
      final email = user['email'] ?? '';
      final password = user['password'] ?? '';
      final passId = user['passId'] ?? '';

      return User(
        id: id,
        username: username,
        email: email,
        password: password,
        passId: passId,
      );
    } else {
      return null;
    }
  }
}
