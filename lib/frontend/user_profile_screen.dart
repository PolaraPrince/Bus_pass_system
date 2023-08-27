import 'package:flutter/material.dart';
import 'package:bus_pass_system/frontend/user_model.dart';
import 'apply_pass_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  UserProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Bus Pass'),
        backgroundColor: Color.fromARGB(255, 100, 223, 75),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 233, 152, 38),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Image.asset('assets/icon.png'),
                    radius: 35,
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pass card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${user.username}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email: ${user.email}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Buttons column
            Column(
              children: [
                // Apply for Pass button
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the ApplyPassScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplyPassScreen(user: user),
                        ),
                      );
                    },
                    child: Text('Apply for Pass'),
                  ),
                ),

                SizedBox(height: 10), // Add some spacing between the buttons

                // Renew Pass button
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement the logic to renew the pass here.
                    },
                    child: Text('Renew Pass'),
                  ),
                ),
              ],
            ),

            // You can add more UI elements as per your design.
          ],
        ),
      ),
    );
  }
}
