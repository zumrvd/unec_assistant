import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/l10n/translations.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/notification_provider.dart';

class SettingsCard2 extends ConsumerWidget {
  const SettingsCard2({required this.onAboutAppTap, super.key});

  final VoidCallback onAboutAppTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final currentTheme = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    final tr = ref.watch(strProvider);

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
          // 1. App Theme
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(Icons.palette_rounded, appColors.yellow15, appColors.yellowDark),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tr.settingsAppTheme,
                        style: _labelStyle(appColors),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  _themeToggle(ref, AppThemeMode.system, currentTheme, appColors, tr.themeSystem),
                  const SizedBox(width: 7),
                  _themeToggle(ref, AppThemeMode.light, currentTheme, appColors, tr.themeLight),
                  const SizedBox(width: 7),
                  _themeToggle(ref, AppThemeMode.dark, currentTheme, appColors, tr.themeDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          const SizedBox(height: 15),

          // 2. Notifications
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(Icons.notifications_rounded, appColors.purple15, appColors.purple),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tr.settingsNotifications,
                        style: _labelStyle(appColors),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
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
                activeThumbColor: appColors.white,
                activeTrackColor: appColors.blue,
                inactiveThumbColor: appColors.white,
                inactiveTrackColor: appColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          const SizedBox(height: 15),

          // 3. About App
          GestureDetector(
            onTap: onAboutAppTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _iconBox(Icons.info_rounded, appColors.pink15, appColors.pink),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr.settingsAboutApp,
                              style: _labelStyle(appColors),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tr.settingsAboutAppVersion,
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
                  child: Icon(Icons.arrow_right_rounded, size: 25, color: appColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          const SizedBox(height: 15),

          // 4. Language
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(Icons.language_rounded, appColors.blue15, appColors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tr.settingsLanguage,
                        style: _labelStyle(appColors),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _LanguagePicker(
                currentLocale: currentLocale,
                appColors: appColors,
                tr: tr,
                onPick: (locale) =>
                    ref.read(localeProvider.notifier).setLocale(locale),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon, Color bgColor, Color iconColor) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 22, color: iconColor),
      );

  TextStyle _labelStyle(AppColors appColors) => GoogleFonts.redditSans(
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: appColors.textPrimary,
      );

  Widget _themeToggle(
    WidgetRef ref,
    AppThemeMode mode,
    AppThemeMode currentMode,
    AppColors appColors,
    String label,
  ) {
    final isSelected = currentMode == mode;
    return GestureDetector(
      onTap: () => ref.read(themeModeProvider.notifier).setMode(mode),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? appColors.navy : appColors.pillUnselectedBg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: appColors.borderColor, width: 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: isSelected ? appColors.white : appColors.pillUnselectedText,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GestureDetector-based language picker (no Material DropdownButton).
// Shows a bottom sheet with the three language options.
// ─────────────────────────────────────────────────────────────────────────────
class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({
    required this.currentLocale,
    required this.appColors,
    required this.tr,
    required this.onPick,
  });

  final AppLocale currentLocale;
  final AppColors appColors;
  final AppStrings tr;
  final void Function(AppLocale) onPick;

  String _label(AppLocale locale) {
    switch (locale) {
      case AppLocale.en:
        return tr.langEnglish;
      case AppLocale.az:
        return tr.langAzerbaijani;
      case AppLocale.ru:
        return tr.langRussian;
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLocale.values.map((locale) {
              final isSelected = locale == currentLocale;
              return GestureDetector(
                onTap: () {
                  onPick(locale);
                  Navigator.of(context).pop();
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _label(locale),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: GoogleFonts.redditSans(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14,
                            color: isSelected ? appColors.blue : appColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_rounded, color: appColors.blue, size: 20),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                _label(currentLocale),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: appColors.white,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down_rounded, color: appColors.white, size: 25),
          ],
        ),
      ),
    );
  }
}
