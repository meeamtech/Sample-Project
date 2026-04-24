import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Todo list smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the empty state is shown
    expect(find.text('All caught up!'), findsOneWidget);
    expect(find.text('Tap + to add a new task'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the add task dialog is shown
    expect(find.text('New Task'), findsOneWidget);

    // Enter some text into the TextField
    await tester.enterText(find.byType(TextField), 'Buy milk');
    
    // Tap the 'Add Task' button
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    // Verify that our new task has been added
    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('1 active task'), findsOneWidget);

    // Tap the checkbox to mark as done
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // Verify that active task count goes to 0
    expect(find.text('0 active tasks'), findsOneWidget);
  });
}
