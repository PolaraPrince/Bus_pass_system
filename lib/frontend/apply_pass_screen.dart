import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bus_pass_system/frontend/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ApplyPassScreen extends StatefulWidget {
  final User user;

  const ApplyPassScreen({super.key, required this.user});

  @override
  _ApplyPassScreenState createState() => _ApplyPassScreenState();
}

class _ApplyPassScreenState extends State<ApplyPassScreen> {
  String? passId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedProfession;
  String? selectedDuration;

  List<String> professions = ['Student', 'Senior Citizen', 'Employee'];
  List<String> durations = [
    '1 Month',
    '3 Months',
    '6 Months',
    '9 Months',
    '12 Months'
  ];

  bool isSubmitted = false; // Flag to track submission status

  double cardHeight = 250.0;

  void resetForm() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    addressController.clear();
    selectedProfession = null;
    selectedDuration = null;
  }

  // Function to generate a random pass ID
  String generatePassID() {
    final random = Random();
    final generatedPassId = 'PASS-${random.nextInt(100000)}';
    return generatedPassId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Pass'),
        backgroundColor: const Color.fromARGB(255, 120, 118, 212),
      ),
      backgroundColor: Color.fromARGB(255, 39, 135, 135),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3, // Add elevation for a shadow effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  // Update the DropdownButtonFormField for Profession
                  DropdownButtonFormField<String>(
                    value: selectedProfession,
                    items: professions.map((profession) {
                      return DropdownMenuItem(
                        value: profession,
                        child: Text(profession),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProfession = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Profession'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your profession';
                      }
                      return null;
                    },
                  ),

                  // Update the TextFormField for Email
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      // Add additional email validation if needed
                      return null;
                    },
                  ),

                  // Update the TextFormField for Mobile No
                  TextFormField(
                    controller: mobileController,
                    decoration: InputDecoration(
                      labelText: 'Mobile No',
                      prefixText: '+91 ',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      // Check if the value contains only numbers and allows optional spaces and the "+91" prefix
                      if (!RegExp(r'^(?:\+91\s?)?\d{10}$').hasMatch(value)) {
                        return 'Please enter a valid mobile number';
                      }
                      return null;
                    },
                  ),

                  // Update the TextFormField for Address
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),

                  // Update the DropdownButtonFormField for Duration
                  DropdownButtonFormField<String>(
                    value: selectedDuration,
                    items: durations.map((duration) {
                      return DropdownMenuItem(
                        value: duration,
                        child: Text(duration),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Duration'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the duration for the pass';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, process the data
                        final name = nameController.text;
                        final email = emailController.text;
                        final mobile = mobileController.text;
                        final address = addressController.text;

                        // Use the selectedProfession and selectedDuration variables for the chosen values
                        final profession = selectedProfession;
                        final duration = selectedDuration;
                        final random = Random();
                        final generatedPassId = 'PASS${random.nextInt(10000)}';
                        // Create a new MongoDB client
                        final mongoClient = mongo.Db(
                            'mongodb://localhost:27017/pass_applications');

                        // Open the connection to the database
                        mongoClient.open().then((_) {
                          // Get the collection
                          final collection =
                              mongoClient.collection('applications');

                          // Insert the pass application data into the collection
                          collection.insert({
                            'passId': generatedPassId,
                            'name': name,
                            'email': email,
                            'mobile': mobile,
                            'address': address,
                            'profession': profession,
                            'duration': duration,
                            'passID': generatedPassId, // Include the pass ID
                          }).then((_) {
                            // Application data is saved successfully.
                            // Generate a random pass ID

                            // Close the MongoDB connection
                            mongoClient.close();

                            // Set the flag, save the pass ID, and reset the form
                            setState(() {
                              isSubmitted = true;
                              passId = generatedPassId;
                              resetForm();
                            });

                            // Show a success message
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Application Submitted'),
                                content: Container(
                                  height: 200, // Adjust the height as needed
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Your pass application has been submitted successfully.',
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Pass ID: $generatedPassId',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 48.0,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(
                                        context,
                                      ); // Go back to the user profile screen
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }).catchError((error) {
                            // Failed to save the application data.
                            // Close the MongoDB connection
                            mongoClient.close();

                            // Show an error message
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Failed to submit pass application.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          });
                        });
                      }
                    },
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 98, 131, 189),
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
}
