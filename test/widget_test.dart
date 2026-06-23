import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unec_assistant/main.dart';

void main() {
  testWidgets('Home dashboard shows provider data', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: UnecAssistantApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Campus announcement'), findsOneWidget);
    expect(find.text('Function 2'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
