import 'package:bus_pass_system/frontend/user_model.dart';
import 'package:flutter/material.dart';

class RenewPassScreen extends StatefulWidget {
  final User user;

  const RenewPassScreen({Key? key, required this.user}) : super(key: key);

  @override
  _RenewPassScreenState createState() => _RenewPassScreenState();
}

class _RenewPassScreenState extends State<RenewPassScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDuration;

  List<String> durations = [
    '1 Month',
    '3 Months',
    '6 Months',
    '9 Months',
    '12 Months'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renew Pass'),
        backgroundColor: const Color.fromARGB(255, 120, 118, 212),
      ),
      backgroundColor: Color.fromARGB(255, 39, 135, 135),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                    decoration:
                        const InputDecoration(labelText: 'New Duration'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the new duration for the pass';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, process the renewal
                        final selectedDuration = this.selectedDuration;

                        // Calculate the new duration using the calculateNewDuration method
                        final newDuration =
                            calculateNewDuration(selectedDuration);

                        // Now, you have the newDuration calculated based on your logic
                        // You can use this value to perform pass renewal logic (update the duration in the database, etc.)

                        // Show a success message or navigate back to the user profile screen
                        // ...
                      }
                    },
                    child: const Text('Renew Pass'),
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

  // Sample method to calculate the new duration based on your logic
  String calculateNewDuration(String? selectedDuration) {
    // Replace this with your own logic to calculate the new duration
    // For now, it simply returns the selected duration as is.
    return selectedDuration ?? '';
  }
}
