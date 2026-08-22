import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import '../../../models/subject_detail.dart';

class SemesterInfoCard extends ConsumerWidget {
  final SubjectDetail data;

  const SemesterInfoCard({required this.data, super.key});

  Widget _infoRow(
    IconData icon,
    Color iconColor,
    String label,
    String value,
    AppColors appColors,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: appColors.textSecondary,
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: appColors.textPrimary,
            ),
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
            fontSize: 15,
            color: appColors.textPrimary,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.subjectsInThisSemester,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: appColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.semesterLabel,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: appColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                _infoRow(
                  Icons.play_circle_rounded,
                  appColors.success,
                  tr.subjectsStartingIn,
                  data.startDate,
                  appColors,
                ),
                const SizedBox(height: 15),
                _infoRow(
                  Icons.stop_circle_rounded,
                  appColors.pink,
                  tr.subjectsEndingIn,
                  data.endDate,
                  appColors,
                ),
                const SizedBox(height: 15),
                _infoRow(
                  Icons.diamond_rounded,
                  appColors.attendanceOrange,
                  tr.subjectsTotalCredits,
                  "${data.totalCredits}",
                  appColors,
                ),
                const SizedBox(height: 15),
                _infoRow(
                  Icons.book_rounded,
                  appColors.primary,
                  tr.subjectsTotalSubjects,
                  "${data.totalSubjects}",
                  appColors,
                ),
                const SizedBox(height: 15),
                _infoRow(
                  Icons.timelapse_rounded,
                  appColors.notificationPurple,
                  tr.subjectsTotalHours,
                  "${data.totalHours}",
                  appColors,
                ),
                const SizedBox(height: 15),
                _infoRow(
                  Icons.access_time_filled_rounded,
                  appColors.red,
                  tr.subjectsAuditoriumHours,
                  "${data.auditoriumHours}",
                  appColors,
                ),
              ],
            ),
          ),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: appColors.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            padding: const EdgeInsets.only(
              left: 50,
              top: 16,
              bottom: 16,
              right: 20,
            ),
            child: Column(
              children: [
                _breakdownRow(tr.subjectsLectures, "${data.lectureHours}", appColors),
                const SizedBox(height: 8),
                _breakdownRow(tr.subjectsSeminars, "${data.seminarHours}", appColors),
                const SizedBox(height: 8),
                _breakdownRow(tr.subjectsLaboratories, "${data.labHours}", appColors),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
