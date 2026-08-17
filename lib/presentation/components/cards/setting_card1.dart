import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';

class SettingsCard1 extends ConsumerWidget {
  const SettingsCard1({
    required this.onProfileInfoTap,
    required this.onUnecCabinetTap,
    required this.onChangePassTap,
    super.key,
  });

  final VoidCallback onProfileInfoTap;
  final VoidCallback onUnecCabinetTap;
  final VoidCallback onChangePassTap;

  Widget _iconBox(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 22,
        color: iconColor,
      ),
    );
  }

  TextStyle _labelStyle(AppColors appColors) {
    return GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 13,
      color: appColors.textPrimary,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onProfileInfoTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(
                      Icons.badge_outlined,
                      appColors.primaryContainer,
                      appColors.primaryOnContainer,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Profile Informations',
                            style: _labelStyle(appColors)),
                        const SizedBox(height: 2),
                        Text(
                          'Your full transcript',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
          Divider(
            color: appColors.divider,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: onUnecCabinetTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(
                      Icons.add_box,
                      appColors.primaryContainer,
                      appColors.primaryOnContainer,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Unec Cabinet', style: _labelStyle(appColors)),
                        const SizedBox(height: 2),
                        Text(
                          'Direct link to your cabinet',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: appColors.iconBoxArrowBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 15,
                    color: appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Divider(
            color: appColors.divider,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: onChangePassTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(
                      Icons.password_rounded,
                      appColors.warningContainer,
                      appColors.warningOnContainer,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Change Password', style: _labelStyle(appColors)),
                        const SizedBox(height: 2),
                        Text(
                          'Resets your password',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
        ],
      ),
    );
  }
}
