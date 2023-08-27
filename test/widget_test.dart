import 'package:bus_pass_system/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

    final Db database = Db('mongodb://localhost:27017/bus_pass_system');
    await tester.pumpWidget(MyApp(database: database));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
