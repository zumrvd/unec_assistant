import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import '../../../providers/about_app_provider.dart';

class SectionLabel extends ConsumerWidget {
  final String label;

  const SectionLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    return Text(
      label,
      style: GoogleFonts.redditSans(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: appColors.textSecondary,
      ),
    );
  }
}

class AboutAppFooter extends ConsumerWidget {
  const AboutAppFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          kFooterCopyright,
          textAlign: TextAlign.center,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: appColors.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          kFooterRights,
          textAlign: TextAlign.center,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: appColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Bu tətbiq '),
              TextSpan(
                text: 'UNEC tələbələri üçün',
                style: GoogleFonts.redditSans(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const TextSpan(text: ' sevgi ilə hazırlanmışdır <3'),
            ],
          ),
          textAlign: TextAlign.center,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: appColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final Widget? trailing;
  final Widget? leading;

  const CustomAppBar({
    required this.title,
    this.onBackTap,
    this.trailing,
    this.leading,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: appColors.background,
          border: Border(bottom: BorderSide(color: appColors.borderColor, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leading ?? GestureDetector(
                    onTap: onBackTap ?? () => Navigator.of(context).pop(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: appColors.iconBoxArrowBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: appColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
