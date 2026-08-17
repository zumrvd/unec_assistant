import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unec_assistant/presentation/components/cards/theme_setting_card.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';

void main() {
  group('Theme System Tests', () {
    test('AppColors light and dark palettes are initialized properly', () {
      const light = AppColors.light();
      const dark = AppColors.dark();

      expect(light.isDark, isFalse);
      expect(dark.isDark, isTrue);

      expect(light.background, const Color(0xFFF8F9FC));
      expect(dark.background, const Color(0xFF0F172A));

      expect(light.primary, const Color(0xFF0569FF));
      expect(dark.primary, const Color(0xFF3B82F6));
    });

    test('ThemeModeNotifier switches modes correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), AppThemeMode.system);

      container.read(themeModeProvider.notifier).setMode(AppThemeMode.dark);
      expect(container.read(themeModeProvider), AppThemeMode.dark);
      expect(container.read(isDarkModeProvider), isTrue);
      expect(container.read(appColorsProvider).isDark, isTrue);

      container.read(themeModeProvider.notifier).setMode(AppThemeMode.light);
      expect(container.read(themeModeProvider), AppThemeMode.light);
      expect(container.read(isDarkModeProvider), isFalse);
      expect(container.read(appColorsProvider).isDark, isFalse);
    });

    testWidgets('ThemeSettingCard renders and toggles theme via tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ThemeSettingCard(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('App Theme'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      // Tap on Dark
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      // Tap on Light
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
    });
  });
}
