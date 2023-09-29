import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Import the QR code scanner package
import 'package:mongo_dart/mongo_dart.dart' as mongo;


class ShowPassScreen extends StatefulWidget {
  final Map<String, dynamic> passDetails;
  const ShowPassScreen({Key? key, required this.passDetails}) : super(key: key);

  @override
  _ShowPassScreenState createState() => _ShowPassScreenState();
}

class _ShowPassScreenState extends State<ShowPassScreen> {
  String? enteredPassId;
  Map<String, dynamic>? passDetails;

  // Define a GlobalKey for the QR code scanner
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  // Function to retrieve pass details from the database based on pass ID
  void fetchPassDetails() async {
    final mongoClient = mongo.Db('mongodb://localhost:27017/pass_applications');
    await mongoClient.open();

    final collection = mongoClient.collection('applications');
    final passDetails = await collection.findOne(
      mongo.where.eq('passId', enteredPassId),
    );

    if (passDetails != null) {
      setState(() {
        this.passDetails = passDetails;
      });
    }

    await mongoClient.close();
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose of the QR code scanner controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Pass'),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Enter Pass ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          enteredPassId = value;
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Enter Pass ID'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (enteredPassId != null &&
                            enteredPassId!.isNotEmpty) {
                          fetchPassDetails();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 98, 131, 189),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0), // Add padding
                      ),
                      child: const Text('Fetch Pass'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (passDetails != null) ...[
                    // Display pass details in a Card format
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Pass ID: ${passDetails!['passId']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Name: ${passDetails!['name']}',
                              ),
                              Text(
                                'Email: ${passDetails!['email']}',
                              ),
                              Text(
                                'Mobile: ${passDetails!['mobile']}',
                              ),
                              Text(
                                'Address: ${passDetails!['address']}',
                              ),
                              Text(
                                'Profession: ${passDetails!['profession']}',
                              ),
                              Text(
                                'Duration: ${passDetails!['duration']}',
                              ),
                              Text(
                                'Expiration Date: ${passDetails!['passExpirationDate']}',
                              ),
                              // Display the QR code for the pass ID
                              Center(
                                child: QrImageView(
                                  data: enteredPassId ??
                                      "", // Use enteredPassId or an empty string
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  key:
                                      qrKey, // Assign the qrKey to the QrImage widget
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
