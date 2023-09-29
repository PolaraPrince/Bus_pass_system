import 'package:bus_pass_system/frontend/Renewpassscreen.dart';
import 'package:bus_pass_system/frontend/passdetailsscreen.dart';
import 'package:flutter/material.dart';


import 'package:bus_pass_system/frontend/user_model.dart';
import 'apply_pass_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isDarkMode = false; // Add a boolean to track dark mode status
  Map<String, dynamic> yourPassDetails = {
    'passId': 'yourPassIdHere',
  };
  @override
  Widget build(BuildContext context) {
    // Use the 'isDarkMode' variable to set the theme mode
    final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeMode, // Set the theme mode
        theme: ThemeData.light(), // Define the light theme
        darkTheme: ThemeData.dark(), // Define the dark theme
        home: Scaffold(
          appBar: AppBar(
            title: const Text('E-Bus Pass'),
            backgroundColor: const Color.fromARGB(255, 120, 118, 212),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 200, 159, 103),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/icon.png'),
                        radius: 35,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.user.username, // Display user's name
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.user.email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
                // Replace the Dark Mode switch with an icon
                ListTile(
                  leading: const Icon(Icons.nightlight_round),
                  title: const Text('Dark Mode'),
                  onTap: () {
                    setState(() {
                      isDarkMode = !isDarkMode; // Toggle dark mode
                    });
                  },
                ),
              ],
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 123, 187, 150),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/userscreen.jpg', // Replace with your image path
                    width: 365, // Adjust the width as needed
                    height: 350, // Adjust the height as needed
                    fit: BoxFit.cover, // Choose the desired fit
                  ),
                  // Buttons column
                  Padding(
                    padding: const EdgeInsets.all(
                        30.0), // Adjust the padding as needed
                    child: Column(
                      children: [
                        // Apply for Pass button
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to the ApplyPassScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplyPassScreen(
                                    user: widget.user,
                                    passId:
                                        'yourPassIdHere', // Replace with the actual pass ID
                                    passExpirationDate: DateTime
                                        .now(), // Replace with the actual expiration date
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 98, 131, 189),
                            ),
                            child: const Text('Apply for Pass'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Add some spacing between the buttons

                        // Renew Pass button
                        SizedBox(
                          width: 200, // Set the desired width
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RenewPassScreen(
                                    user: widget.user,
                                    passId:
                                        'yourPassIdHere', // Replace with the actual pass ID
                                    passExpirationDate: DateTime
                                        .now(), // Replace with the actual expiration date
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 98, 131, 189),
                            ),
                            child: const Text('Renew Pass'),
                          ),
                        ),
                        const SizedBox(height: 10), // Add spacing

                        // Show Pass button
                        SizedBox(
                          width: 200, // Set the desired width
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowPassScreen(
                                      passDetails: yourPassDetails),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 98, 131, 189),
                            ),
                            child: const Text('Show Pass'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
