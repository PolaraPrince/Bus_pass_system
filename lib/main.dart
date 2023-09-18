import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'frontend/login_screen.dart';
import 'frontend/signup_screen.dart';

void main() async {
  final database = await initDatabase();
  runApp(MyApp(database: database));
}

Future<Db> initDatabase() async {
  final db = Db('mongodb://localhost:27017/bus_pass_system');
  await db.open();
  return db;
}

class MyApp extends StatelessWidget {
  final Db database;
  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Pass System',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(database: database),
        '/signup': (context) => SignUpScreen(database: database),
      },
    );
  }
}
