import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unec_assistant/screens/functions/functions_main_screen.dart';
import 'package:unec_assistant/presentation/components/buttons/current_class_button.dart';
import 'package:unec_assistant/presentation/components/buttons/schedule_button.dart';
import 'package:unec_assistant/presentation/components/buttons/attendance/attendance_button.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subjects_button.dart';
import 'package:unec_assistant/presentation/components/buttons/notes_button.dart';

void main() {
  testWidgets('FunctionsMainScreen renders without throwing exceptions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: FunctionsMainScreen(),
        ),
      ),
    );
    
    // Check if the screen renders and does not throw the layout exception
    expect(tester.takeException(), isNull);
    
    expect(find.byType(FunctionsMainScreen), findsOneWidget);
    expect(find.byType(CurrentClassButton), findsOneWidget);
    expect(find.byType(ScheduleButton), findsOneWidget);
    expect(find.byType(AttendanceButton), findsOneWidget);
    expect(find.byType(SubjectsButton), findsOneWidget);
    expect(find.byType(NotesButton), findsOneWidget);
  });
}
