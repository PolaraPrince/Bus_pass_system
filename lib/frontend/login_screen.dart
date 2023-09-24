import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bus_pass_system/frontend/user_model.dart';
import 'signup_screen.dart';
import 'user_profile_screen.dart'; // Import UserProfileScreen
// Import the User class

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
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
                // Text field for password.
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
                            builder: (context) => UserProfileScreen(
                                user: user), // Navigate to UserProfileScreen
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
                  child: const Text('Login'),
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
                  child: const Text('Sign Up'),
                ),
              ],
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
      // Check if 'id' is not null before accessing it
      final id = user['id'] ?? '';
      final username = user['username'] ?? '';
      final email = user['email'] ?? '';
      final password = user['password'] ?? '';

      return User(
        id: id,
        username: username,
        email: email,
        password: password,
        // You might need to fetch other fields as needed
      );
    } else {
      // User not found, return null
      return null;
    }
  }
}
