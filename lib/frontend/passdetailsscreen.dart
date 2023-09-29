import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ShowPassScreen extends StatefulWidget {
  @override
  _ShowPassScreenState createState() => _ShowPassScreenState();
}

class _ShowPassScreenState extends State<ShowPassScreen> {
  String? enteredPassId;
  Map<String, dynamic>?
      passDetails; // Store pass details retrieved from the database

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Pass'),
        backgroundColor: Color.fromARGB(255, 120, 118, 212),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    decoration: InputDecoration(labelText: 'Enter Pass ID'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (enteredPassId != null && enteredPassId!.isNotEmpty) {
                        fetchPassDetails();
                      }
                    },
                    child: Text('Fetch Pass'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 98, 131, 189),
                      padding:
                          EdgeInsets.symmetric(vertical: 12.0), // Add padding
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                            style: TextStyle(
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
                            child: Container(
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
