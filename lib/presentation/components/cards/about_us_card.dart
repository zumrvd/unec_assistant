import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';

class AboutUsCard extends ConsumerWidget {
  const AboutUsCard({super.key});

  Widget _aboutSection({
    required String emoji,
    required String heading,
    required InlineSpan body,
    required AppColors appColors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              heading,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: appColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text.rich(
          body,
          softWrap: true,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: appColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _aboutSection(
            emoji: '👋',
            heading: tr.aboutUsHelloHeading,
            appColors: appColors,
            body: TextSpan(
              children: [
                TextSpan(text: tr.aboutUsHelloBodyPre),
                TextSpan(
                  text: tr.aboutUsHelloBodyBold,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    color: appColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: tr.aboutUsHelloBodyPost,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _aboutSection(
            emoji: '🚀',
            heading: tr.aboutUsStartedHeading,
            appColors: appColors,
            body: TextSpan(
              children: [
                TextSpan(
                  text: tr.aboutUsStartedBody,
                ),
                TextSpan(
                  text: tr.aboutUsStartedItalic,
                  style: GoogleFonts.redditSans(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    color: appColors.textPrimary,
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
