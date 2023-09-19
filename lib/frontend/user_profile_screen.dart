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
          backgroundColor: const Color.fromARGB(255, 75, 223, 129),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 168, 71),
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
              // Dark/Light mode switch
              SwitchListTile(
                title: Text('Dark Mode'),
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value; // Update the dark mode status
                  });
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
              // Buttons column
              Column(
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
                            builder: (context) =>
                                ApplyPassScreen(user: widget.user),
                          ),
                        );
                      },
                      child: const Text('Apply for Pass'),
                    ),
                  ),
                  const SizedBox(
                      height: 10), // Add some spacing between the buttons

                  // Renew Pass button
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement the logic to renew the pass here.
                      },
                      child: const Text('Renew Pass'),
                    ),
                  ),

                  const SizedBox(height: 10), // Add spacing

                  // Show Pass button
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement logic to show the pass here.
                      },
                      child: const Text('Show Pass'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
