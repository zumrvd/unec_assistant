import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';

class ThemeSettingCard extends ConsumerWidget {
  const ThemeSettingCard({super.key});

  static const _themeOptions = [
    AppThemeMode.system,
    AppThemeMode.light,
    AppThemeMode.dark,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final currentMode = ref.watch(themeModeProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: appColors.borderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: appColors.warningContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.palette_rounded,
                    size: 22,
                    color: appColors.warningOnContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'App Theme',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: appColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: _themeOptions.map((mode) {
              final isSelected = currentMode == mode;
              return Padding(
                padding: const EdgeInsets.only(left: 7),
                child: GestureDetector(
                  onTap: () =>
                      ref.read(themeModeProvider.notifier).setMode(mode),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appColors.pillSelectedBg
                          : appColors.pillUnselectedBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: appColors.borderColor,
                        width: 1,
                      ),
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
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
