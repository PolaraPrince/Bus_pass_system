import 'package:bus_pass_system/frontend/user_model.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class RenewPassScreen extends StatefulWidget {
  final User user;

  const RenewPassScreen({
    Key? key,
    required this.user, required String passId, required DateTime passExpirationDate,
  }) : super(key: key);

  @override
  _RenewPassScreenState createState() => _RenewPassScreenState();
}

class _RenewPassScreenState extends State<RenewPassScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedExtension;
  String remainingTimeString = '';
  DateTime? currentExpirationDate;
  DateTime? newExpirationDate;
  String? enteredPassId; // Added to store entered pass ID

  List<String> extensions = [
    '1 Month',
    '3 Months',
    '6 Months',
    '9 Months',
    '12 Months',
  ];

  @override
  void initState() {
    super.initState();
  }

  void fetchPassDetails() async {
    final mongoClient = mongo.Db('mongodb://localhost:27017/pass_applications');
    await mongoClient.open();

    final collection = mongoClient.collection('applications');
    final passDetails = await collection.findOne(
      mongo.where.eq('passId', enteredPassId), // Use entered pass ID
    );

    if (passDetails != null) {
      final expirationDate = passDetails['passExpirationDate'] as DateTime;
      setState(() {
        currentExpirationDate = expirationDate;
        calculateRemainingTime();
      });
    }

    await mongoClient.close();
  }

  void calculateRemainingTime() {
    if (currentExpirationDate != null) {
      final now = DateTime.now();
      final remainingTime = currentExpirationDate!.difference(now);

      final remainingDays = remainingTime.inDays;
      final remainingHours = remainingTime.inHours % 24;

      setState(() {
        remainingTimeString = '$remainingDays days $remainingHours hours';
      });
    }
  }

  void extendPass() async {
    if (selectedExtension != null) {
      newExpirationDate = calculateNewExpirationDate(selectedExtension);

      final mongoClient =
          mongo.Db('mongodb://localhost:27017/pass_applications');
      await mongoClient.open();

      final collection = mongoClient.collection('applications');
      await collection.update(
        mongo.where.eq('passId', enteredPassId), // Use entered pass ID
        mongo.modify.set('passExpirationDate', newExpirationDate),
      );

      await mongoClient.close();

      setState(() {
        currentExpirationDate = newExpirationDate;
        calculateRemainingTime();
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pass Extended'),
            content:
                Text('Your pass has been extended until $newExpirationDate.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  DateTime calculateNewExpirationDate(String? selectedExtension) {
    if (currentExpirationDate != null && selectedExtension != null) {
      int monthsToAdd = 0;

      switch (selectedExtension) {
        case '1 Month':
          monthsToAdd = 1;
          break;
        case '3 Months':
          monthsToAdd = 3;
          break;
        case '6 Months':
          monthsToAdd = 6;
          break;
        case '9 Months':
          monthsToAdd = 9;
          break;
        case '12 Months':
          monthsToAdd = 12;
          break;
      }

      return currentExpirationDate!.add(Duration(days: 30 * monthsToAdd));
    } else {
      return currentExpirationDate ?? DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renew Pass'),
        backgroundColor: const Color.fromARGB(255, 120, 118, 212),
      ),
      backgroundColor: const Color.fromARGB(255, 39, 135, 135),
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
                  TextFormField(
                    // Text input for pass ID
                    onChanged: (value) {
                      setState(() {
                        enteredPassId = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter Pass ID',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Pass ID';
                      }
                      return null;
                    },
                  ),
                  Text(
                    'Pass ID: $enteredPassId', // Display entered pass ID
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Remaining Time: $remainingTimeString',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedExtension,
                    items: extensions.map((extension) {
                      return DropdownMenuItem(
                        value: extension,
                        child: Text(extension),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedExtension = value;
                      });
                    },
                    decoration:
                        const InputDecoration(labelText: 'Extension Duration'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the extension duration';
                      }
                      return null;
                    },
                  ),
                 
                  ElevatedButton(
                    
                    onPressed: () {
                      if (enteredPassId != null &&
                          _formKey.currentState!.validate()) {
                        extendPass();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 98, 131, 189),
                    ),
                    child: const Text('Extend Pass'),
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
