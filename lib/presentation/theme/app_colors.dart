import 'package:flutter/material.dart';

@immutable
class AppColors {
  final bool isDark;

  // ---------------------------------------------------------------------------
  // Hero Palette - Static Constants
  // ---------------------------------------------------------------------------
  static const Color backgroundLight = Color(0xFFF8F9FC);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF1F1F1F);
  static const Color trueBlackColor = Color(0xFF000000);
  static const Color strokeColor = Color(0xFFE0E4F0);

  static const Color blueColor = Color(0xFF0569FF);
  static const Color blue15Color = Color(0x260569FF);
  static const Color blue50Color = Color(0x800569FF);
  static const Color darkBlueColor = Color(0xFF1C488A);
  static const Color navyColor = Color(0xFF2C415C);
  static const Color lightBlueColor = Color(0xFFE8F0FE);

  static const Color grayColor = Color(0xFF838A97);
  static const Color gray50Color = Color(0x80838A97);
  static const Color gray15Color = Color(0x26838A97);

  static const Color greenColor = Color(0xFF0F6E11);
  static const Color green15Color = Color(0x260F6E11);
  static const Color green2Color = Color(0xFF3B6D11);

  static const Color yellowColor = Color(0xFFE3993C);
  static const Color yellowDarkColor = Color(0xFF854F0B);
  static const Color yellow15Color = Color(0x26E3993C);
  static const Color yellowTextColor = Color(0xFF985909);

  static const Color redColor = Color(0xFF993C1D);
  static const Color red15Color = Color(0x26993C1D);

  static const Color orangeRedColor = Color(0xFFD54829);
  static const Color orangeRed15Color = Color(0x26D54829);

  static const Color pinkColor = Color(0xFFDA4979);
  static const Color pink15Color = Color(0x26DA4979);

  static const Color deepPinkColor = Color(0xFFE16890);
  static const Color deepPink15Color = Color(0x26E16890);

  static const Color purpleColor = Color(0xFF534AB7);
  static const Color purple15Color = Color(0x26534AB7);

  static const Color nowIndicatorColor = Color(0xFFF65959);
  static const Color dangerColor = Color(0xFFD54829);

  // ---------------------------------------------------------------------------
  // Instance Color Properties (Theme Aware)
  // ---------------------------------------------------------------------------

  // Direct Hero Color Accessors
  final Color white;
  final Color black;
  final Color trueBlack;
  final Color stroke;

  final Color blue;
  final Color blue15;
  final Color blue50;
  final Color darkBlue;
  final Color navy;
  final Color lightBlue;

  final Color gray;
  final Color gray50;
  final Color gray15;

  final Color green;
  final Color green15;
  final Color green2;

  final Color yellow;
  final Color yellowDark;
  final Color yellow15;
  final Color yellowText;

  final Color red;
  final Color red15;

  final Color orangeRed;
  final Color orangeRed15;

  final Color pink;
  final Color pink15;

  final Color deepPink;
  final Color deepPink15;

  final Color purple;
  final Color purple15;

  final Color nowIndicator;

  // Backgrounds & Surfaces
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color inputBackground;

  // Borders & Dividers
  final Color borderColor;
  final Color divider;

  // Typography
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;

  // Primary & Containers
  final Color primary;
  final Color primaryContainer;
  final Color primaryOnContainer;

  // Accents & Status
  final Color danger;
  final Color dangerContainer;
  final Color dangerOnContainer;

  final Color warning;
  final Color warningContainer;
  final Color warningOnContainer;

  final Color notificationPurple;
  final Color notificationPurpleContainer;

  final Color infoPink;
  final Color infoPinkContainer;

  final Color heartColor;
  final Color badgeRed;

  // UI Components / Controls
  final Color pillSelectedBg;
  final Color pillSelectedText;
  final Color pillUnselectedBg;
  final Color pillUnselectedText;

  final Color navActive;
  final Color navInactive;
  final Color navIndicatorBg;
  final Color iconBoxArrowBg;
  final Color dropdownBg;
  final Color placeholderImageBg;
  final Color placeholderImageIcon;

  const AppColors({
    required this.isDark,
    required this.white,
    required this.black,
    required this.trueBlack,
    required this.stroke,
    required this.blue,
    required this.blue15,
    required this.blue50,
    required this.darkBlue,
    required this.navy,
    required this.lightBlue,
    required this.gray,
    required this.gray50,
    required this.gray15,
    required this.green,
    required this.green15,
    required this.green2,
    required this.yellow,
    required this.yellowDark,
    required this.yellow15,
    required this.yellowText,
    required this.red,
    required this.red15,
    required this.orangeRed,
    required this.orangeRed15,
    required this.pink,
    required this.pink15,
    required this.deepPink,
    required this.deepPink15,
    required this.purple,
    required this.purple15,
    required this.nowIndicator,
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.inputBackground,
    required this.borderColor,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.primary,
    required this.primaryContainer,
    required this.primaryOnContainer,
    required this.danger,
    required this.dangerContainer,
    required this.dangerOnContainer,
    required this.warning,
    required this.warningContainer,
    required this.warningOnContainer,
    required this.notificationPurple,
    required this.notificationPurpleContainer,
    required this.infoPink,
    required this.infoPinkContainer,
    required this.heartColor,
    required this.badgeRed,
    required this.pillSelectedBg,
    required this.pillSelectedText,
    required this.pillUnselectedBg,
    required this.pillUnselectedText,
    required this.navActive,
    required this.navInactive,
    required this.navIndicatorBg,
    required this.iconBoxArrowBg,
    required this.dropdownBg,
    required this.placeholderImageBg,
    required this.placeholderImageIcon,
  });

  const AppColors.light()
    : isDark = false,
      white = whiteColor,
      black = blackColor,
      trueBlack = trueBlackColor,
      stroke = strokeColor,
      blue = blueColor,
      blue15 = blue15Color,
      blue50 = blue50Color,
      darkBlue = darkBlueColor,
      navy = navyColor,
      lightBlue = lightBlueColor,
      gray = grayColor,
      gray50 = gray50Color,
      gray15 = gray15Color,
      green = greenColor,
      green15 = green15Color,
      green2 = green2Color,
      yellow = yellowColor,
      yellowDark = const Color.fromARGB(255, 239, 140, 19),
      yellow15 = yellow15Color,
      yellowText = yellowTextColor,
      red = redColor,
      red15 = red15Color,
      orangeRed = orangeRedColor,
      orangeRed15 = orangeRed15Color,
      pink = pinkColor,
      pink15 = pink15Color,
      deepPink = deepPinkColor,
      deepPink15 = deepPink15Color,
      purple = purpleColor,
      purple15 = purple15Color,
      nowIndicator = nowIndicatorColor,
      background = backgroundLight,
      surface = whiteColor,
      cardBackground = whiteColor,
      inputBackground = backgroundLight,
      borderColor = strokeColor,
      divider = strokeColor,
      textPrimary = blackColor,
      textSecondary = grayColor,
      textMuted = gray50Color,
      textInverse = whiteColor,
      primary = blueColor,
      primaryContainer = lightBlueColor,
      primaryOnContainer = blueColor,
      danger = orangeRedColor,
      dangerContainer = orangeRed15Color,
      dangerOnContainer = orangeRedColor,
      warning = yellowDarkColor,
      warningContainer = yellow15Color,
      warningOnContainer = yellowDarkColor,
      notificationPurple = purpleColor,
      notificationPurpleContainer = purple15Color,
      infoPink = pinkColor,
      infoPinkContainer = pink15Color,
      heartColor = pinkColor,
      badgeRed = const Color(0xFFFF3B30),
      pillSelectedBg = navyColor,
      pillSelectedText = whiteColor,
      pillUnselectedBg = backgroundLight,
      pillUnselectedText = grayColor,
      navActive = blueColor,
      navInactive = grayColor,
      navIndicatorBg = blue15Color,
      iconBoxArrowBg = gray15Color,
      dropdownBg = blueColor,
      placeholderImageBg = lightBlueColor,
      placeholderImageIcon = const Color(0xFF75A4FF);

  const AppColors.dark()
    : isDark = true,
      white = const Color(0xFFFFFFFF),
      black = const Color(0xFF1F1F1F),
      trueBlack = const Color(0xFF000000),
      stroke = const Color(0xFF334155),
      blue = const Color(0xFF3B82F6),
      blue15 = const Color(0x333B82F6),
      blue50 = const Color(0x803B82F6),
      darkBlue = const Color(0xFF1E3A8A),
      navy = const Color(0xFF3B82F6),
      lightBlue = const Color(0xFF1E3A8A),
      gray = const Color(0xFF94A3B8),
      gray50 = const Color(0x8094A3B8),
      gray15 = const Color(0x3394A3B8),
      green = const Color(0xFF34D399),
      green15 = const Color(0x3334D399),
      green2 = const Color(0xFF4ADE80),
      yellow = const Color(0xFFFBBF24),
      yellowDark = const Color(0xFFF59E0B),
      yellow15 = const Color(0x33FBBF24),
      yellowText = const Color(0xFFFDE68A),
      red = const Color(0xFFF87171),
      red15 = const Color(0x33F87171),
      orangeRed = const Color(0xFFEF4444),
      orangeRed15 = const Color(0x33EF4444),
      pink = const Color(0xFFF472B6),
      pink15 = const Color(0x33F472B6),
      deepPink = const Color(0xFFFB7185),
      deepPink15 = const Color(0x33FB7185),
      purple = const Color(0xFF818CF8),
      purple15 = const Color(0x33818CF8),
      nowIndicator = const Color(0xFFF87171),
      background = const Color(0xFF0F172A),
      surface = const Color(0xFF1E293B),
      cardBackground = const Color(0xFF1E293B),
      inputBackground = const Color(0xFF0F172A),
      borderColor = const Color(0xFF334155),
      divider = const Color(0xFF334155),
      textPrimary = const Color(0xFFF8FAFC),
      textSecondary = const Color(0xFF94A3B8),
      textMuted = const Color(0x8094A3B8),
      textInverse = const Color(0xFF0F172A),
      primary = const Color(0xFF3B82F6),
      primaryContainer = const Color(0xFF1E3A8A),
      primaryOnContainer = const Color(0xFF93C5FD),
      danger = const Color(0xFFEF4444),
      dangerContainer = const Color(0xFF450A0A),
      dangerOnContainer = const Color(0xFFFCA5A5),
      warning = const Color(0xFFF59E0B),
      warningContainer = const Color(0x33F59E0B),
      warningOnContainer = const Color(0xFFFDE68A),
      notificationPurple = const Color(0xFF818CF8),
      notificationPurpleContainer = const Color(0x33818CF8),
      infoPink = const Color(0xFFF472B6),
      infoPinkContainer = const Color(0x33F472B6),
      heartColor = const Color(0xFFF43F5E),
      badgeRed = const Color(0xFFEF4444),
      pillSelectedBg = const Color(0xFF3B82F6),
      pillSelectedText = const Color(0xFFFFFFFF),
      pillUnselectedBg = const Color(0xFF0F172A),
      pillUnselectedText = const Color(0xFF94A3B8),
      navActive = const Color(0xFF3B82F6),
      navInactive = const Color(0xFF64748B),
      navIndicatorBg = const Color(0x333B82F6),
      iconBoxArrowBg = const Color(0x3394A3B8),
      dropdownBg = const Color(0xFF1E3A8A),
      placeholderImageBg = const Color(0xFF1E293B),
      placeholderImageIcon = const Color(0xFF3B82F6);

  Color get error => danger;
  Color get success => green;
  Color get successContainer => green15;
  Color get attendanceOrange => isDark ? const Color(0xFFFB923C) : orangeRed;
  Color get buttonDisabledBg => borderColor;
}
