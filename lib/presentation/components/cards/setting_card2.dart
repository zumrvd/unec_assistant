import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/notification_provider.dart';

class SettingsCard2 extends ConsumerStatefulWidget {
  const SettingsCard2({required this.onAboutAppTap, super.key});

  final VoidCallback onAboutAppTap;

  @override
  ConsumerState<SettingsCard2> createState() => _SettingsCardState();
}

class _SettingsCardState extends ConsumerState<SettingsCard2> {
  String _selectedLanguage = 'English';

  static const _themeOptions = [
    AppThemeMode.system,
    AppThemeMode.light,
    AppThemeMode.dark,
  ];
  static const _languageOptions = [
    'English',
    'Azərbaycan dili',
    'Русский язык',
  ];

  Widget _iconBox(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 22, color: iconColor),
    );
  }

  TextStyle _labelStyle(AppColors appColors) {
    return GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 13,
      color: appColors.textPrimary,
    );
  }

  Widget _themeToggle(
    AppThemeMode mode,
    AppThemeMode currentMode,
    AppColors appColors,
  ) {
    final isSelected = currentMode == mode;
    return GestureDetector(
      onTap: () => ref.read(themeModeProvider.notifier).setMode(mode),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.pillSelectedBg
              : appColors.pillUnselectedBg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: appColors.borderColor, width: 1),
        ),
        child: Text(
          mode.label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: isSelected
                ? appColors.pillSelectedText
                : appColors.pillUnselectedText,
          ),
        ),
      ),
    );
  }

  Widget _languageDropdown(AppColors appColors) {
    final textStyle = GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 11,
      color: appColors.pillSelectedText,
    );

    return Container(
      decoration: BoxDecoration(
        color: appColors.dropdownBg,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 37,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          onChanged: (val) => setState(() => _selectedLanguage = val!),
          dropdownColor: appColors.dropdownBg,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: appColors.pillSelectedText,
            size: 25,
          ),
          style: textStyle,
          selectedItemBuilder: (context) {
            return _languageOptions
                .map(
                  (option) => Align(
                    alignment: Alignment.centerLeft,
                    child: Text(option, style: textStyle),
                  ),
                )
                .toList();
          },
          items: _languageOptions
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option, style: textStyle),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final currentTheme = ref.watch(themeModeProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(
                      Icons.palette_rounded,
                      appColors.warningContainer,
                      appColors.warningOnContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('App Theme', style: _labelStyle(appColors)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  _themeToggle(_themeOptions[0], currentTheme, appColors),
                  const SizedBox(width: 7),
                  _themeToggle(_themeOptions[1], currentTheme, appColors),
                  const SizedBox(width: 7),
                  _themeToggle(_themeOptions[2], currentTheme, appColors),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(
                      Icons.notifications_rounded,
                      appColors.notificationPurpleContainer,
                      appColors.notificationPurple,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Notifications',
                        style: _labelStyle(appColors),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: ref.watch(notificationsEnabledProvider),
                onChanged: (val) =>
                    ref.read(notificationsEnabledProvider.notifier).toggle(val),
                activeThumbColor: appColors.pillSelectedText,
                activeTrackColor: appColors.primary,
                inactiveThumbColor: appColors.pillSelectedText,
                inactiveTrackColor: appColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: widget.onAboutAppTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _iconBox(
                        Icons.info_rounded,
                        appColors.infoPinkContainer,
                        appColors.infoPink,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('About App', style: _labelStyle(appColors)),
                            const SizedBox(height: 2),
                            Text(
                              'v 1.1.0 IT team inc.',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 9,
                                color: appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: appColors.iconBoxArrowBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_right_rounded,
                    size: 25,
                    color: appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(
                      Icons.language_rounded,
                      appColors.primaryContainer,
                      appColors.primaryOnContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Language', style: _labelStyle(appColors)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _languageDropdown(appColors),
            ],
          ),
        ],
      ),
    );
  }
}
