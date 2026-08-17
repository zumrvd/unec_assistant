import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unec_assistant/main.dart';
import 'package:unec_assistant/providers/current_class_provider.dart';
import 'package:unec_assistant/routing/main_scaffold.dart';

void main() {
  testWidgets('App renders main scaffold and navigation items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nowTickerProvider.overrideWith(
            (ref) => Stream.value(DateTime(2026, 8, 17, 10, 0)),
          ),
        ],
        child: const UnecAssistantApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GlobalAppBar), findsOneWidget);
    expect(find.byType(MainScaffold), findsOneWidget);
    expect(find.bySemanticsLabel('Home'), findsOneWidget);
    expect(find.bySemanticsLabel('Functions'), findsOneWidget);
    expect(find.bySemanticsLabel('Feed'), findsOneWidget);
    expect(find.bySemanticsLabel('Profile'), findsOneWidget);
  });
}
