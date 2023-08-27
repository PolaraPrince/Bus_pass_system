import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:bus_pass_system/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final Db database = Db('mongodb://localhost:27017/bus_pass_system');
    await tester.pumpWidget(MyApp(database: database));

    // Find the widget that displays the counter value
    final counterTextFinder = find.text('Counter: 0');
    expect(counterTextFinder,
        findsOneWidget); // Verify that the initial counter value is displayed as "0"

    // Tap on the icon to increment the counter
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter value updates to "Counter: 1"
    expect(find.text('Counter: 1'), findsOneWidget);
  });
}
