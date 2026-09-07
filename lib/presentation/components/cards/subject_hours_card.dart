import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import '../../../models/subject_detail.dart';

class SubjectHoursCard extends ConsumerWidget {
  final SubjectDetail data;

  const SubjectHoursCard({required this.data, super.key});

  Widget _hoursRow(String label, String value, AppColors appColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: appColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: appColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _breakdownRow(String label, String value, AppColors appColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.subdirectory_arrow_right_rounded,
              size: 20,
              color: appColors.borderColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: appColors.textSecondary,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: appColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);
    final iconColor = appColors.notificationPurple;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    Icons.access_time_filled_rounded,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  tr.subjectHoursTitle,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _hoursRow(
              tr.subjectsTotalHours,
              "${data.subjectTotalHours}hrs",
              appColors,
            ),
          ),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _hoursRow(
              tr.subjectsAuditoriumHours,
              "${data.subjectAuditoriumHours}hrs",
              appColors,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: appColors.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: appColors.divider, thickness: 1, height: 1),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 16, right: 30),
                  child: Text(
                    tr.subjectHoursBreakdown,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: appColors.textMuted,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 6,
                  ),
                  child: _breakdownRow(
                    tr.subjectsLectures,
                    "${data.subjectLectureHours}hrs",
                    appColors,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 6,
                  ),
                  child: _breakdownRow(
                    tr.subjectsSeminars,
                    "${data.subjectSeminarHours}hrs",
                    appColors,
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
