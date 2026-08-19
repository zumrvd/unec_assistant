import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unec_assistant/presentation/components/cards/student_id_card.dart';
import 'package:unec_assistant/presentation/components/lists/labels.dart';
import 'package:unec_assistant/screens/profile/student_card_screen.dart';

void main() {
  testWidgets('StudentCardScreen renders CustomAppBar and StudentIdCard shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: StudentCardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.text('Student ID Card'), findsOneWidget);
    expect(find.byType(StudentIdCard), findsOneWidget);
    expect(find.text('Card Theme'), findsOneWidget);
    expect(find.text('Avatar & Photo'), findsOneWidget);
    expect(find.text('Campus Motto'), findsOneWidget);
    expect(find.text('Surprise Vibe'), findsOneWidget);
    expect(find.text('Save & Return'), findsOneWidget);
  });

  testWidgets('StudentCardScreen shows discard warning dialog when leaving with unsaved changes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: StudentCardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Make an edit (select Initials)
    await tester.tap(find.text('Initials'));
    await tester.pumpAndSettle();

    // Tap the back button on CustomAppBar
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify AlertDialog appears
    expect(find.text('Unsaved Changes'), findsOneWidget);
    expect(find.text('Discard'), findsOneWidget);
    expect(find.text('Keep Editing'), findsOneWidget);
  });
}
