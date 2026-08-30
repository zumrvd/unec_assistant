import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import '../../../models/subject_detail.dart';

class SubjectCreditCard extends ConsumerWidget {
  final SubjectDetail data;

  const SubjectCreditCard({required this.data, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);
    final iconColor = appColors.warning;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.diamond_rounded,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  tr.subjectCreditTitle,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 110,
                  decoration: BoxDecoration(
                    color: appColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: appColors.borderColor, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      "${data.subjectCredit}",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: appColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_rounded,
                            size: 20,
                            color: appColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tr.subjectCreditWhatAre,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: appColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: appColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: appColors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: tr.subjectCreditDesc1,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: appColors.textSecondary,
                                ),
                              ),
                              TextSpan(
                                text: tr.subjectCreditDesc2,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: appColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: tr.subjectCreditDesc3,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: appColors.textSecondary,
                                ),
                              ),
                              TextSpan(
                                text: tr.subjectCreditDesc4,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: appColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
