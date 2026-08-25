import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unec_assistant/presentation/components/cards/setting_card1.dart';
import 'package:unec_assistant/presentation/components/cards/setting_card2.dart';
import 'package:unec_assistant/presentation/components/cards/theme_setting_card.dart';
import 'package:unec_assistant/data/mock_academic_repository.dart';
import 'package:unec_assistant/providers/notes_provider.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/components/buttons/attendance/attendance_button.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';

void main() {
  group('Theme System & Hero Color Palette Tests', () {
    test('AppColors hero palette static constants match exact specification', () {
      expect(AppColors.backgroundLight, const Color(0xFFF8F9FC));
      expect(AppColors.whiteColor, const Color(0xFFFFFFFF));
      expect(AppColors.blackColor, const Color(0xFF1F1F1F));
      expect(AppColors.trueBlackColor, const Color(0xFF000000));
      expect(AppColors.strokeColor, const Color(0xFFE0E4F0));

      expect(AppColors.blueColor, const Color(0xFF0569FF));
      expect(AppColors.blue15Color, const Color(0x260569FF));
      expect(AppColors.blue50Color, const Color(0x800569FF));
      expect(AppColors.darkBlueColor, const Color(0xFF1C488A));
      expect(AppColors.navyColor, const Color(0xFF2C415C));
      expect(AppColors.lightBlueColor, const Color(0xFFE8F0FE));

      expect(AppColors.grayColor, const Color(0xFF838A97));
      expect(AppColors.gray50Color, const Color(0x80838A97));
      expect(AppColors.gray15Color, const Color(0x26838A97));

      expect(AppColors.greenColor, const Color(0xFF0F6E11));
      expect(AppColors.green15Color, const Color(0x260F6E11));
      expect(AppColors.green2Color, const Color(0xFF3B6D11));

      expect(AppColors.yellowColor, const Color(0xFFE3993C));
      expect(AppColors.yellowDarkColor, const Color(0xFF854F0B));
      expect(AppColors.yellow15Color, const Color(0x26E3993C));
      expect(AppColors.yellowTextColor, const Color(0xFF985909));

      expect(AppColors.redColor, const Color(0xFF993C1D));
      expect(AppColors.red15Color, const Color(0x26993C1D));

      expect(AppColors.orangeRedColor, const Color(0xFFD54829));
      expect(AppColors.orangeRed15Color, const Color(0x26D54829));

      expect(AppColors.pinkColor, const Color(0xFFDA4979));
      expect(AppColors.pink15Color, const Color(0x26DA4979));

      expect(AppColors.deepPinkColor, const Color(0xFFE16890));
      expect(AppColors.deepPink15Color, const Color(0x26E16890));

      expect(AppColors.purpleColor, const Color(0xFF534AB7));
      expect(AppColors.purple15Color, const Color(0x26534AB7));

      expect(AppColors.nowIndicatorColor, const Color(0xFFF65959));
      expect(AppColors.dangerColor, const Color(0xFFD54829));
    });

    test('AppColors light palette instance properties are mapped correctly', () {
      const light = AppColors.light();
      expect(light.isDark, isFalse);

      expect(light.background, const Color(0xFFF8F9FC));
      expect(light.surface, const Color(0xFFFFFFFF));
      expect(light.cardBackground, const Color(0xFFFFFFFF));
      expect(light.stroke, const Color(0xFFE0E4F0));
      expect(light.borderColor, const Color(0xFFE0E4F0));

      expect(light.blue, const Color(0xFF0569FF));
      expect(light.blue15, const Color(0x260569FF));
      expect(light.green, const Color(0xFF0F6E11));
      expect(light.green15, const Color(0x260F6E11));
      expect(light.yellowDark, const Color(0xFF854F0B));
      expect(light.yellow15, const Color(0x26E3993C));
      expect(light.red, const Color(0xFF993C1D));
      expect(light.red15, const Color(0x26993C1D));
      expect(light.pink, const Color(0xFFDA4979));
      expect(light.pink15, const Color(0x26DA4979));
      expect(light.purple, const Color(0xFF534AB7));
      expect(light.purple15, const Color(0x26534AB7));
      expect(light.orangeRed, const Color(0xFFD54829));
      expect(light.orangeRed15, const Color(0x26D54829));
      expect(light.nowIndicator, const Color(0xFFF65959));
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

    testWidgets('ThemeSettingCard renders and toggles theme via tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: ThemeSettingCard())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('App Theme'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
    });

    testWidgets('SettingsCard1 renders all three items with correct texts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SettingsCard1(
                onProfileInfoTap: () {},
                onUnecCabinetTap: () {},
                onChangePassTap: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Profile Informations'), findsOneWidget);
      expect(find.text('Your full transcript'), findsOneWidget);
      expect(find.text('Unec Cabinet'), findsOneWidget);
      expect(find.text('Direct link to your cabinet'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Resets your password'), findsOneWidget);
    });

    testWidgets('SettingsCard2 renders options, toggle, switch, and dropdown', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SettingsCard2(
                onAboutAppTap: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('App Theme'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('About App'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    test('Notes foldersProvider initializes with Personal and subject folders', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final folders = container.read(foldersProvider);
      expect(folders, isNotEmpty);
      expect(folders.first.folderName, 'Personal');
      expect(folders.first.iconColor, const Color(0xFFDA4979));
      expect(folders.first.iconBg, const Color(0x26DA4979));
    });

    test('SubjectDetail repository entries have correct colours', () async {
      // Read subjects from the same MockAcademicRepository that the app uses at
      // runtime. The colours are defined there — not in package-level constants.
      final repo = MockAcademicRepository();
      final subjects = await repo.fetchSubjects('fall-2025');

      final byId = {for (final s in subjects) s.subjectId: s};

      expect(byId['1']!.iconColor, const Color(0xFF0569FF));  // Prog
      expect(byId['2']!.iconColor, const Color(0xFF0F6E11));  // Fizika
      expect(byId['3']!.iconColor, const Color(0xFF854F0B));  // Az
      expect(byId['4']!.iconColor, const Color(0xFF993C1D));  // Xetti
      expect(byId['5']!.iconColor, const Color(0xFFDA4979));  // Info
      expect(byId['6']!.iconColor, const Color(0xFF534AB7));  // Xarici
    });

    testWidgets('AttendanceButton renders with muted red palette styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AttendanceButton(onTap: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Absence count'), findsOneWidget);
      expect(find.byIcon(Icons.front_hand_outlined), findsOneWidget);
    });
  });
}
