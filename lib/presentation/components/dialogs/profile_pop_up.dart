import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';

class ProfilePopUp extends ConsumerWidget {
  const ProfilePopUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    return Dialog(
      alignment: Alignment.topRight,
      insetPadding: const EdgeInsets.only(top: 80, right: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: appColors.surface,
      elevation: 0,
      child: Container(
        width: 330,
        decoration: BoxDecoration(
          border: Border.all(color: appColors.borderColor, width: 1),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close and Email Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'zverdiyevaa9@gmail.com',
                    style: GoogleFonts.redditSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: appColors.textPrimary,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: appColors.iconBoxArrowBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: appColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Icon Large
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColors.primary,
              ),
              alignment: Alignment.center,
              child: Text(
                'Z.V',
                style: GoogleFonts.redditSans(
                  color: appColors.pillSelectedText,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Greeting
            Text(
              'Merhaba Zümrüd!',
              style: GoogleFonts.redditSans(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Manage Account Button
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: appColors.borderColor),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  tr.popupManageAccount,
                  style: GoogleFonts.redditSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: appColors.borderColor, width: 1),
                ),
                child: Column(
                  children: [
                    _ActionTile(
                      icon: Icons.person_add_alt_1_outlined,
                      label: tr.popupAddAccount,
                      onTap: () {},
                      appColors: appColors,
                    ),
                    Divider(height: 1, indent: 56, color: appColors.divider),
                    _ActionTile(
                      icon: Icons.logout_rounded,
                      label: tr.popupSignOut,
                      onTap: () {},
                      appColors: appColors,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FooterLink(label: tr.popupPrivacyPolicy, appColors: appColors),
                Text(
                  ' • ',
                  style: GoogleFonts.redditSans(color: appColors.textSecondary),
                ),
                _FooterLink(label: tr.popupTermsOfService, appColors: appColors),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final AppColors appColors;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: appColors.textPrimary, size: 22),
            const SizedBox(width: 18),
            Text(
              label,
              style: GoogleFonts.redditSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final AppColors appColors;

  const _FooterLink({required this.label, required this.appColors});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.redditSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: appColors.textSecondary,
      ),
    );
  }
}
