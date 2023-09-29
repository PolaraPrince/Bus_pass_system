import 'package:flutter/material.dart';
class PassDetailsScreen extends StatelessWidget {
  final String name;
  final String email;
  final String mobile;
  final String address;
  final String profession;
  final String duration;

  const PassDetailsScreen({super.key, 
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.profession,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pass Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            Text('Email: $email'),
            Text('Mobile: $mobile'),
            Text('Address: $address'),
            Text('Profession: $profession'),
            Text('Duration: $duration'),
            // Add more pass details as needed
          ],
        ),
      ),
    );
  }
}
