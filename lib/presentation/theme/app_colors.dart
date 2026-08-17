import 'package:flutter/material.dart';

@immutable
class AppColors {
  final bool isDark;

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
        background = const Color(0xFFF8F9FC),
        surface = const Color(0xFFFFFFFF),
        cardBackground = const Color(0xFFFFFFFF),
        inputBackground = const Color(0xFFF8F9FC),
        borderColor = const Color(0xFFE0E4F0),
        divider = const Color(0xFFE0E4F0),
        textPrimary = const Color(0xFF1F1F1F),
        textSecondary = const Color(0xFF838A97),
        textMuted = const Color(0x80838A97),
        textInverse = const Color(0xFFFFFFFF),
        primary = const Color(0xFF0569FF),
        primaryContainer = const Color(0xFFE8F0FE),
        primaryOnContainer = const Color(0xFF0569FF),
        danger = const Color(0xFFD54829),
        dangerContainer = const Color(0xFFFFE5E5),
        dangerOnContainer = const Color(0xFFD54829),
        warning = const Color(0xFF854F0B),
        warningContainer = const Color(0x26E3993C),
        warningOnContainer = const Color(0xFF854F0B),
        notificationPurple = const Color(0xFF534AB7),
        notificationPurpleContainer = const Color(0x26534AB7),
        infoPink = const Color(0xFFDA4979),
        infoPinkContainer = const Color(0x26DA4979),
        heartColor = const Color(0xFFDA4979),
        badgeRed = const Color(0xFFFF3B30),
        pillSelectedBg = const Color(0xFF2C415C),
        pillSelectedText = const Color(0xFFFFFFFF),
        pillUnselectedBg = const Color(0xFFF8F9FC),
        pillUnselectedText = const Color(0xFF838A97),
        navActive = const Color(0xFF0569FF),
        navInactive = const Color(0xFF838A97),
        navIndicatorBg = const Color(0x260569FF),
        iconBoxArrowBg = const Color(0x26838A97),
        dropdownBg = const Color(0xFF0569FF),
        placeholderImageBg = const Color(0xFFE8F0FE),
        placeholderImageIcon = const Color(0xFF75A4FF);

  const AppColors.dark()
      : isDark = true,
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
  Color get success => isDark ? const Color(0xFF34D399) : const Color(0xFF059669);
  Color get attendanceOrange => isDark ? const Color(0xFFFB923C) : const Color(0xFFD56829);
  Color get buttonDisabledBg => isDark ? const Color(0xFF334155) : const Color(0xFFE0E4F0);
}

