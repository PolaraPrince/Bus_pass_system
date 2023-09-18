import 'package:flutter/material.dart';
import 'package:bus_pass_system/frontend/user_model.dart';
import 'apply_pass_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final UserProfile user;

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
                    backgroundImage: AssetImage('assets/images/icone.png'),
                    radius: 35,
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.name, // Display user's name
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${user.name}', // Display user's name
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Profession: ${user.profession}', // Display user's profession
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email: ${user.email}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Mobile No: ${user.mobile}', // Display user's mobile number
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Address: ${user.address}', // Display user's address
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Duration: ${user.duration}', // Display user's selected duration
                      style: TextStyle(fontSize: 16),
                    ),
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
          ],
        ),
      ),
    );
  }
}
