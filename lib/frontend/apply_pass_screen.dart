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

  void resetForm() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    addressController.clear();
    selectedProfession = null;
    selectedDuration = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Pass'),
      ),
      body: Padding(
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add additional email validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: mobileController,
                decoration: const InputDecoration(labelText: 'Mobile No'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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

                    // Create a new MongoDB client
                    final mongoClient =
                        mongo.Db('mongodb://localhost:27017/pass_applications');

                    // Open the connection to the database
                    mongoClient.open().then((_) {
                      // Get the collection
                      final collection = mongoClient.collection('applications');

                      // Insert the pass application data into the collection
                      collection.insert({
                        'name': name,
                        'email': email,
                        'mobile': mobile,
                        'address': address,
                        'profession': profession,
                        'duration': duration,
                      }).then((_) {
                        // Application data is saved successfully.
                        // Close the MongoDB connection
                        mongoClient.close();

                        // Set the flag and reset the form
                        setState(() {
                          isSubmitted = true;
                          resetForm();
                        });

                        // Show a success message
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Application Submitted'),
                            content: const Text(
                                'Your pass application has been submitted successfully.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(
                                      context); // Go back to the user profile screen
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
